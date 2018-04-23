//
//  FamilyViewController.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/18/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import UIKit

class FamilyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var menu: UIVisualEffectView!
    @IBOutlet weak var familyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageData = UserDefaults.standard.string(forKey: "familyPic") {
            familyImageView.image = UIImage.base64Convert(base64String: imageData)
        }
        familyImageView.layer.cornerRadius = familyImageView.frame.width / 2
        familyImageView.layer.masksToBounds = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
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
        button1.addTarget(self, action: #selector(individualMode), for: .touchUpInside)
        menu.contentView.addSubview(button1)
        let button2 = UIButton(frame: CGRect(x: 0, y: 66, width: 173, height: 50))
        button2.setTitle("", for: .normal)
        button2.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
        menu.contentView.addSubview(button2)
        
        let label1 = UILabel(frame: CGRect(x: 23, y: 33, width: 104, height: 21))
        label1.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label1.textColor = UIColor.black.withAlphaComponent(0.4)
        label1.text = "Individual"
        menu.contentView.addSubview(label1)
        
        let label2 = UILabel(frame: CGRect(x: 23, y: 75, width: 104, height: 21))
        label2.font = UIFont.systemFont(ofSize: 21, weight: .bold)
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
    
    @objc func individualMode() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [], animations: {
            self.menu.frame = CGRect(x: -193, y: 0, width: 173, height: self.view.frame.height)
        }, completion: { _ in
            self.presentingViewController?.dismiss(animated: false, completion: nil)
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

