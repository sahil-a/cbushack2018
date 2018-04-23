//
//  ViewController.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/12/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    var isChoosingAuthenticationMethod = true
    var isChoosingNew = false
    var login = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func topButtonPressed(_ sender: Any) {
        if isChoosingAuthenticationMethod {
            isChoosingAuthenticationMethod = false
            login = true
            topButton.setTitle("Child", for: .normal)
            bottomButton.setTitle("Parent", for: .normal)
        } else if !isChoosingNew {
            UserDefaults.standard.setValue("Child", forKeyPath: "userType")
            if login {
                performSegue(withIdentifier: "login", sender: self)
                isChoosingAuthenticationMethod = true
                topButton.setTitle("Login", for: .normal)
                bottomButton.setTitle("Register", for: .normal)
            } else {
                performSegue(withIdentifier: "registerExisting", sender: self)
                isChoosingAuthenticationMethod = true
                topButton.setTitle("Login", for: .normal)
                bottomButton.setTitle("Register", for: .normal)
            }
        } else {
            performSegue(withIdentifier: "registerNew", sender: self)
            isChoosingAuthenticationMethod = true
            isChoosingNew = false
            topButton.setTitle("Login", for: .normal)
            bottomButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func bottomButtonPressed(_ sender: Any) {
        if isChoosingAuthenticationMethod {
            isChoosingAuthenticationMethod = false
            login = false
            topButton.setTitle("Child", for: .normal)
            bottomButton.setTitle("Parent", for: .normal)
        } else if !isChoosingNew  {
            UserDefaults.standard.setValue("Parent", forKeyPath: "userType")
            if login {
                performSegue(withIdentifier: "login", sender: self)
                isChoosingAuthenticationMethod = true
                topButton.setTitle("Login", for: .normal)
                bottomButton.setTitle("Register", for: .normal)
            } else {
                isChoosingNew = true
                topButton.setTitle("New", for: .normal)
                bottomButton.setTitle("Existing", for: .normal)
            }
        } else {
            performSegue(withIdentifier: "registerExisting", sender: self)
            isChoosingAuthenticationMethod = true
            isChoosingNew = false
            topButton.setTitle("Login", for: .normal)
            bottomButton.setTitle("Register", for: .normal)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
