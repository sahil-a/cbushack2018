//
//  LoginViewController.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/17/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var nameTextField: CustomTextField!
    var familyCodeTextField: CustomTextField!
    @IBOutlet weak var topLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField = CustomTextField.instanceFromNib()
        nameTextField.frame = CGRect(x: 16, y: 124, width: 340, height: 30)
        nameTextField.textField.placeholder = "Full Name"
        view.addSubview(nameTextField)
        
        familyCodeTextField = CustomTextField.instanceFromNib()
        familyCodeTextField.frame = CGRect(x: 16, y: 124 + 30 + 23, width: 340, height: 30)
        familyCodeTextField.textField.placeholder = "Family Code"
        view.addSubview(familyCodeTextField)
        
        topLabel.text = UserDefaults.standard.string(forKey: "userType")
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let code = familyCodeTextField.text
        let name = nameTextField.text.trimmingCharacters(in: [" "])
        PointService.login(name: name, hashedCode: code.sha256()) { success in
            DispatchQueue.main.async {
                if !success {
                    let alertView = UIAlertController(title: "Invalid Credentials", message: "Please double check your full name and family code and retry login.", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertView, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
