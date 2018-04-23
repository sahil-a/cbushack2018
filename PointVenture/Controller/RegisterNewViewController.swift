//
//  RegisterNewViewController.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/17/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import UIKit
import MMSProfileImagePicker

class RegisterNewViewController: UIViewController, MMSProfileImagePickerDelegate {

    var nameTextField: CustomTextField!
    var displayNameTextField: CustomTextField!
    var familyTextField: CustomTextField!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var familyImageView: UIImageView!
    var pickingFamilyImage = false
    let picker = MMSProfileImagePicker()
    let code = KeyGen.newKey()
    var setFamilyImage = false
    var setPersonalImage = false
    @IBOutlet weak var manualOverrideSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        familyTextField = CustomTextField.instanceFromNib()
        familyTextField.frame = CGRect(x: 16, y: 124, width: 340, height: 30)
        familyTextField.textField.placeholder = "Family Name"
        view.addSubview(familyTextField)
        
        nameTextField = CustomTextField.instanceFromNib()
        nameTextField.frame = CGRect(x: 16, y: 124 + 30 + 23, width: 340, height: 30)
        nameTextField.textField.placeholder = "Full Name"
        view.addSubview(nameTextField)
        
        displayNameTextField = CustomTextField.instanceFromNib()
        displayNameTextField.frame = CGRect(x: 16, y: 124 + (30 + 23) * 2, width: 340, height: 30)
        displayNameTextField.textField.placeholder = "Display Name"
        view.addSubview(displayNameTextField)
        
        topLabel.text = "First " + UserDefaults.standard.string(forKey: "userType")!
        picker.delegate = self
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        familyImageView.layer.cornerRadius = familyImageView.frame.width / 2
        familyImageView.layer.masksToBounds = true
    }
    
    @IBAction func editFamilyPic(_ sender: Any) {
        picker.select(fromPhotoLibrary: self)
        pickingFamilyImage = true
    }
    
    @IBAction func editPersonalPic(_ sender: Any) {
        picker.select(fromPhotoLibrary: self)
        pickingFamilyImage = false
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
    
    @IBAction func registerPressed(_ sender: Any) {
        let parent = Individual(isParent: true, name: nameTextField.text, displayName: displayNameTextField.text)
        var family = Family(name: familyTextField.text, hashedCode: code.sha256(), individuals: [parent])
        family.manualOverrideEnabled = manualOverrideSwitch.isOn
        PointService.new(family: family, completion: { success in
            DispatchQueue.main.async {
                guard success else {
                    let alertView = UIAlertController(title: "Server Error", message: "Could not create a new account at the moment. Please try again later.", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertView, animated: true, completion: nil)
                    return
                }
                let alertView = UIAlertController(title: "Welcome to PointVenture", message: "Your family code is \(self.code). Give it to others in your family so that they can join", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    
                    self.performSegue(withIdentifier: "register", sender: self)
                }))
                self.present(alertView, animated: true, completion: nil)
                if self.setPersonalImage {
                    let imageData = self.profileImageView.image!.base64String()
                    UserDefaults.standard.set(imageData, forKey: "profilePic")
                    PointService.upload(image: self.profileImageView.image!, individualKey: PointService.individual!.primaryKey!, completion: { (success) in
                    })
                } else {
                    UserDefaults.standard.set(nil, forKey: "profilePic")
                }
                if self.setFamilyImage {
                    let imageData = self.familyImageView.image!.base64String()
                    UserDefaults.standard.set(imageData, forKey: "familyPic")
                    PointService.upload(image: self.familyImageView.image!, individualKey: PointService.family!.primaryKey!, completion: { (success) in
                    })
                } else {
                    UserDefaults.standard.set(nil, forKey: "familyPic")
                }
            }
        })
    }
    
    func mmsImagePickerController(_ picker: MMSProfileImagePicker, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage]
        (pickingFamilyImage ? familyImageView : profileImageView).image = image as? UIImage
        if (pickingFamilyImage ? familyImageView : profileImageView).image != nil {
            if pickingFamilyImage {
                setFamilyImage = true
            } else {
                setPersonalImage = true
            }
        }
    }
    
    func mmsImagePickerControllerDidCancel(_ picker: MMSProfileImagePicker) {
        dismiss(animated: true, completion: nil)
    }
}
