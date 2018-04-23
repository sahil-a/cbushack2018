//
//  RegisterExistingViewController.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/17/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import UIKit
import MMSProfileImagePicker

class RegisterExistingViewController: UIViewController, MMSProfileImagePickerDelegate {

    var nameTextField: CustomTextField!
    var displayNameTextField: CustomTextField!
    var familyCodeTextField: CustomTextField!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    let picker = MMSProfileImagePicker()
    var setProfilePic = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField = CustomTextField.instanceFromNib()
        nameTextField.frame = CGRect(x: 16, y: 124, width: 340, height: 30)
        nameTextField.textField.placeholder = "Full Name"
        view.addSubview(nameTextField)
        
        displayNameTextField = CustomTextField.instanceFromNib()
        displayNameTextField.frame = CGRect(x: 16, y: 124 + 30 + 23, width: 340, height: 30)
        displayNameTextField.textField.placeholder = "Display Name"
        view.addSubview(displayNameTextField)
        
        familyCodeTextField = CustomTextField.instanceFromNib()
        familyCodeTextField.frame = CGRect(x: 16, y: 124 + (30 + 23) * 2, width: 340, height: 30)
        familyCodeTextField.textField.placeholder = "Family Code"
        view.addSubview(familyCodeTextField)
        
        topLabel.text = "New " + UserDefaults.standard.string(forKey: "userType")!
        picker.delegate = self
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
    }

    @IBAction func editPic(_ sender: Any) {
        picker.select(fromPhotoLibrary: self)
    }
    
    @IBAction func back(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let code = familyCodeTextField.text
        let user = Individual(isParent: topLabel.text == "New Parent", name: nameTextField.text, displayName: displayNameTextField.text)
        PointService.new(user: user, hashedCode: code.sha256()) { (success) in
            DispatchQueue.main.async {
                guard success else {
                    let alertView = UIAlertController(title: "Server Error", message: "Could not create a new account at the moment. Please try again later.", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertView, animated: true, completion: nil)
                    return
                }
                if self.setProfilePic {
                    let imageData = self.profileImageView.image!.base64String()
                    UserDefaults.standard.set(imageData, forKey: "profilePic")
                    PointService.upload(image: self.profileImageView.image!, individualKey: PointService.individual!.primaryKey!, completion: { (success) in
                    })
                } else {
                    UserDefaults.standard.set(nil, forKey: "profilePic")
                }
                self.performSegue(withIdentifier: "register", sender: self)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    func mmsImagePickerController(_ picker: MMSProfileImagePicker, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage]
        profileImageView.image = image as? UIImage
        if profileImageView.image != nil {
            setProfilePic = true
        }
    }
    
    func mmsImagePickerControllerDidCancel(_ picker: MMSProfileImagePicker) {
        dismiss(animated: true, completion: nil)
    }
}
