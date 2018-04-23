//
//  IndividualViewController.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/17/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import UIKit

class IndividualViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ConnectionManagerDelegate {
    var menu: UIVisualEffectView!
    var family = PointService.family!
    var individual = PointService.individual!
    var others: [Individual] = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var alone: UILabel!
    var profilePics: [String: UIImage] = [:]
    var connectionManager: ConnectionManager!
    var statuses: [String: Bool] = [:]
    var challenger: Individual!
    var delegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if (delegate.pointsUsed != nil) {
            let transfer = max(delegate.pointsUsedByChallenger, delegate.pointsUsed)
            if delegate.pointsUsed > delegate.pointsUsedByChallenger {
                PointService.individual!.points -= transfer
                if var person = (others.filter{$0.primaryKey == delegate.challenger.primaryKey!}).first {
                    person.points += transfer
                }
                if var person = (family.individuals.filter{$0.primaryKey == delegate.challenger.primaryKey!}).first {
                    person.points += transfer
                }
            } else if delegate.pointsUsedByChallenger > delegate.pointsUsed {
                PointService.individual!.points += transfer
                if var person = (others.filter{$0.primaryKey == delegate.challenger.primaryKey!}).first {
                    person.points -= transfer
                }
                if var person = (family.individuals.filter{$0.primaryKey == delegate.challenger.primaryKey!}).first {
                    person.points -= transfer
                }
            }
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageData = UserDefaults.standard.string(forKey: "profilePic") {
            profileImageView.image = UIImage.base64Convert(base64String: imageData)
        }
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        if family.individualKeys.count == 1 {
            alone.isHidden = false
        }
        others = family.individuals.filter { $0.primaryKey != individual.primaryKey }
        if family.individuals.count != family.individualKeys.count {
            let fetchKeys = family.individualKeys.filter { item in
                for user in self.family.individuals {
                    if user.primaryKey == item {
                        return false
                    }
                }
                return true
            }
            for key in fetchKeys {
                PointService.getIndividual(primaryKey: key, completion: { (user) in
                    DispatchQueue.main.async {
                        guard let user = user else {
                            print("error getting individual from server")
                            return
                        }
                        self.others.append(user)
                        self.collectionView.reloadData()
                        PointService.downloadImage(primaryKey: key, completion: { (image) in
                            if let image = image {
                                self.profilePics[key] = image
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            }
                        })
                    }
                })
            }
        }
        connectionManager = ConnectionManager()
        connectionManager.delegate = self
    }
    
    func changeInPeers(peers: [String]) {
        for peer in peers {
            statuses[peer] = true
        }
        for (name, condition) in statuses {
            if condition && !peers.contains(name) {
                statuses[name] = false
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func connected(to: String) {
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as! AppDelegate).connectionManager = self.connectionManager
            (UIApplication.shared.delegate as! AppDelegate).challenger = self.challenger
            (UIApplication.shared.delegate as! AppDelegate).challengerPic = self.profilePics[self.challenger.primaryKey!]
            self.performSegue(withIdentifier: "challenge", sender: self)
        }
    }
    
    func disconnected(from: String) {
        
    }
    
    func recieved(data: Data) {
        
    }
    
    func recieved(data: String) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return others.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        cell.nameLabel.text = others[indexPath.row].displayName
        cell.subLabel.text = String(others[indexPath.row].points)
        if let image = profilePics[others[indexPath.row].primaryKey!] {
            cell.imageView.image = image
        }
        if let status = statuses[others[indexPath.row].displayName] {
            cell.nearby = status
        } else {
            cell.nearby = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = others[indexPath.row].displayName
        if statuses[name] ?? false {
            connectionManager.invite(peer: name)
            self.challenger = others[indexPath.row]
            (UIApplication.shared.delegate as! AppDelegate).isInitiator = true
        }
    }
    
    func shouldAcceptInvitationFrom(peer: String, handler: @escaping (Bool) -> Void) {
        if (others.map {$0.displayName}).contains(peer) {
            let alertView = UIAlertController(title: "You have been challenged by \(peer)", message: "Do you accept the challenge?", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Yes", style: .default, handler: { _ in
                (UIApplication.shared.delegate as! AppDelegate).isInitiator = false
                self.challenger = (self.others.filter {$0.displayName == peer}).first!
                handler(true)
            })
            let deny = UIAlertAction(title: "No", style: .default, handler: {_ in
                handler(false)
            })
            alertView.addAction(accept)
            alertView.addAction(deny)
            present(alertView, animated: true, completion: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func openMenu(_ sender: Any) {
        menu = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        menu.alpha = 0.8
        menu.backgroundColor = .white
        menu.layer.shadowColor = UIColor.black.cgColor
        menu.layer.masksToBounds = false
        menu.layer.shadowColor = UIColor.black.cgColor
        menu.layer.shadowOpacity = 0.2
        menu.layer.shadowOffset = CGSize(width: 0, height: 0)
        menu.layer.shadowRadius = 2
        menu.frame = CGRect(x: -173, y: 0, width: 173, height: view.frame.height)
        view.addSubview(menu)
        let button1 = UIButton(frame: CGRect(x: 0, y: 16, width: 173, height: 50))
        button1.setTitle("", for: .normal)
        button1.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
        menu.contentView.addSubview(button1)
        let button2 = UIButton(frame: CGRect(x: 0, y: 66, width: 173, height: 50))
        button2.setTitle("", for: .normal)
        button2.addTarget(self, action: #selector(familyMode), for: .touchUpInside)
        menu.contentView.addSubview(button2)
        
        let label1 = UILabel(frame: CGRect(x: 23, y: 33, width: 104, height: 21))
        label1.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label1.text = "Individual"
        menu.contentView.addSubview(label1)
        
        let label2 = UILabel(frame: CGRect(x: 23, y: 75, width: 104, height: 21))
        label2.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label2.textColor = UIColor.black.withAlphaComponent(0.4)
        label2.text = "Family"
        menu.contentView.addSubview(label2)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 7, options: [], animations: {
             self.menu.frame = CGRect(x: 0, y: 0, width: 173, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func closeMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [], animations: {
            self.menu.frame = CGRect(x: -193, y: 0, width: 173, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func familyMode() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [], animations: {
            self.menu.frame = CGRect(x: -193, y: 0, width: 173, height: self.view.frame.height)
        }, completion: { _ in
            self.performSegue(withIdentifier: "family", sender: self)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: self.view)
            if !(menu?.frame.contains(loc) ?? true) {
                closeMenu()
            }
        }
    }
}

extension UIImage {
    class func base64Convert(base64String: String) -> UIImage {
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        return decodedimage!
    }
    
    func base64String() -> String {
        let imageData: Data = UIImagePNGRepresentation(self)!
        return imageData.base64EncodedString()
    }
}
