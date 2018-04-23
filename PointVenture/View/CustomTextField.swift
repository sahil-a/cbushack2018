//
//  CustomTextField.swift
//  Scheduling Pro

import UIKit

class CustomTextField: UIView, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var editingIndicatorView: UIView!
    var text: String {
        get {
            return textField.text ?? ""
        }
        set {
            textField.text = newValue
        }
    }
    let editingColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.3)
    let normalColor = UIColor(red: 203 / 255, green: 203 / 255, blue: 203 / 255, alpha: 1)
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingIndicatorView.backgroundColor = editingColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        editingIndicatorView.backgroundColor = normalColor
    }
    class func instanceFromNib() -> CustomTextField {
        return UINib(nibName: "CustomTextField", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTextField
    }
}
