//
//  ConnectionManager.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/22/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class ConnectionManager : NSObject {
    
    private let serviceType = "pointventure"
    private var peers: [MCPeerID] = []
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        return session
    }()
    
    private let myPeerId = MCPeerID(displayName: PointService.individual!.displayName)
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    var delegate: ConnectionManagerDelegate?
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func invite(peer: String) {
        let peerID = (peers.filter {$0.displayName == peer}).first!
        serviceBrowser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 100)
    }
    
    func send(_ message: String) {
        try? self.session.send(message.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
    }
    
    func send(_ data: Data) {
        try? self.session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
}

extension ConnectionManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        delegate?.shouldAcceptInvitationFrom(peer: peerID.displayName, handler: { (response) in
            if response {
                invitationHandler(true, self.session)
            } else {
                invitationHandler(false, nil)
            }
        })
    }
    
}

extension ConnectionManager : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        peers.append(peerID)
        delegate?.changeInPeers(peers: peers.map {$0.displayName})
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
        for peer in peers {
            if peer.displayName == peerID.displayName {
                peers.remove(at: peers.index(of: peer)!)
                delegate?.changeInPeers(peers: peers.map {$0.displayName})
            }
        }
    }
    
}

extension ConnectionManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        if state == .connected {
            delegate?.connected(to: peerID.displayName)
        } else if state == .notConnected {
            delegate?.disconnected(from: peerID.displayName)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(String(data: data, encoding: .utf8) ?? "")")
        if let message = String(data: data, encoding: .utf8) {
            delegate?.recieved(data: message)
        } else {
            delegate?.recieved(data: data)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
}

protocol ConnectionManagerDelegate {
    func changeInPeers(peers: [String])
    func shouldAcceptInvitationFrom(peer: String, handler: @escaping (Bool) -> Void)
    func connected(to: String)
    func disconnected(from: String)
    func recieved(data: Data)
    func recieved(data: String)
}
