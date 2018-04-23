//
//  ChallengeViewController.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/18/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController, ConnectionManagerDelegate {
    
    @IBOutlet weak var checkView: UIImageView!
    
    func changeInPeers(peers: [String]) {
        
    }
    
    func shouldAcceptInvitationFrom(peer: String, handler: @escaping (Bool) -> Void) {
        
    }
    
    func connected(to: String) {
        
    }
    
    func disconnected(from: String) {
        DispatchQueue.main.async {
            self.delegate.pointsUsed = Int(self.pointLabel.text!)!
            self.delegate.pointsUsedByChallenger = self.challengerPoints
            self.performSegue(withIdentifier: "finish", sender: self)
        }
    }
    
    func recieved(data: Data) {
        
    }
    
    func recieved(data: String) {
        DispatchQueue.main.async {
            if let frame = DataFrame.deserialize(json: data) as? DataFrame {
                if !frame.ready {
                    if !self.delegate.isInitiator {
                        self.inputField.text = frame.text
                    }
                    self.challengerDone = false
                } else {
                    self.challengerDone = true
                    self.challengerPoints = frame.pointsUsed
                    if self.done {
                        self.delegate.connectionManager.session.disconnect()
                    }
                }
            }
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var pointerView: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    var moving: Bool = false
    var max: Int!
    var timer: Timer!
    var delegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    @IBOutlet weak var inputField: UITextView!
    var done: Bool = false
    var challengerDone: Bool = false
    var challengerPoints: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        max = PointService.individual!.points
        delegate.connectionManager.delegate = self
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        topLabel.text = delegate.challenger.displayName
        if let image = delegate.challengerPic {
            imageView.image = image
        } else {
            PointService.downloadImage(primaryKey: delegate.challenger.primaryKey!, completion: { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            })
        }
        pointLabel.text = String(max / 4)
        if !delegate.isInitiator {
            self.inputField.text = "What \(delegate.challenger.displayName) wants"
            self.inputField.isEditable = false
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                let frame = DataFrame(ready: false, pointsUsed: Int(self.pointLabel.text!)!, text: self.inputField.text ?? "What \(PointService.individual!.displayName) wants")
                self.delegate.connectionManager.send(frame.serialize()!)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        for touch in touches {
            handleTouch(touch, initial: true)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            handleTouch(touch, initial: false)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moving = false
    }
    
    @IBAction func done(_ sender: Any) {
        done = !done
        checkView.isHidden = !done
        if done {
            let frame = DataFrame(ready: true, pointsUsed: Int(self.pointLabel.text!)!, text: "")
            self.delegate.connectionManager.send(frame.serialize()!)
            if delegate.isInitiator {
                timer.invalidate()
            }
        } else {
            if delegate.isInitiator {
                timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                    let frame = DataFrame(ready: false, pointsUsed: Int(self.pointLabel.text!)!, text: self.inputField.text ?? "What \(PointService.individual!.displayName) wants")
                    self.delegate.connectionManager.send(frame.serialize()!)
                }
            }
        }
    }
    
    func handleTouch(_ touch: UITouch, initial: Bool) {
        let p1 = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        let p2 = CGPoint(x: 359, y: p1.y)
        let p3 = touch.location(in: view)
        let d12 = sqrt(pow(Double(p2.x - p1.x), 2) + pow(Double(p2.y - p1.y), 2))
        let d13 = sqrt(pow(Double(p3.x - p1.x), 2) + pow(Double(p3.y - p1.y), 2))
        let d23 = sqrt(pow(Double(p3.x - p2.x), 2) + pow(Double(p3.y - p2.y), 2))
        let angle = CGFloat(acos((pow(d12, 2) + pow(d13, 2) - pow(d23, 2)) / (2 * d12 * d13)))
        if ((d13 < 160 && d13 > 100) || (!initial && moving) ) {
            pointerView.transform = CGAffineTransform(rotationAngle: (p3.y - p1.y < 0) ? -angle : angle)
            moving = true
            var eqAngle = Double((p3.y - p1.y < 0) ? -angle : angle) + (Double.pi / 2)
            while eqAngle < 0 {
                eqAngle += 2 * Double.pi
            }
            while eqAngle > 2 * Double.pi {
                eqAngle -= 2 * Double.pi
            }
            let prop = eqAngle / (2 * Double.pi)
            pointLabel.text = String(Int(Double(max) * prop))
        } else {
            moving = false
        }
    }
}

struct DataFrame: Serializable {
    var ready: Bool
    var pointsUsed: Int
    var text: String
}
