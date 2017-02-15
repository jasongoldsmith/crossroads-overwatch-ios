//
//  LoginBaseViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/24/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class LoginBaseViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var BottomNextButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonStatus()
        //        Key Board Observer
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButtonStatus()
    }
    
    @IBAction override func navBackButtonPressed(sender: UIBarButtonItem?) {
        if let navController = navigationController {
            if navController.viewControllers.count == 1 {
                navController.dismiss(animated: true, completion: nil)
            } else {
                navController.popViewController(animated: true)
                navController.navigationBar.isHidden = true
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        if BottomNextButtonConstraint.constant != 0.0 {
            view.endEditing(true)
        }
    }
    
    @IBAction func showHidePassword() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        let trackingRequest = AppTrackingRequest()
        trackingRequest.sendApplicationPushNotiTracking(notiDict: nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SHOW_PASSWORD, completion: {didSucceed in
        })
    }
    
    func dismissView() {
        dismissViewController(isAnimated: true, dismissed: { (didDismiss) in
            
        })
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [String : AnyObject] = sender.userInfo! as! [String : AnyObject]
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.cgRectValue.size
        let keyBoardHeight = keyboardSize.height
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        BottomNextButtonConstraint.constant = keyBoardHeight
        UIView.animate(withDuration: animationDuration!, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [String : AnyObject] = sender.userInfo! as! [String : AnyObject]
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        BottomNextButtonConstraint.constant = 0.0
        UIView.animate(withDuration: animationDuration!, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    //Active - inactive states for the buttons
    func setInactiveStatusForButton() {
        nextButton.backgroundColor = UIColor.metallicBlue
        nextButton.setTitleColor(UIColor.lightBlueGrey, for: .normal)
    }

    func setActiveStatusForButton() {
        nextButton.backgroundColor = UIColor.tangerine
        nextButton.setTitleColor(UIColor.white, for: .normal)
    }

    func areTheFieldsValid() -> Bool {
        if let email = emailTextField.text,
            let password = passwordTextField.text,
            email.isValidEmail,
            password.isValidPassword {
            return true
        }
        return false
    }

    func updateButtonStatus() {
        if areTheFieldsValid() {
            setActiveStatusForButton()
        } else {
            setInactiveStatusForButton()
        }
    }

    //UITextField delegate methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
        let selectedRange = textField.selectedTextRange else {
            return true
        }
        let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        if cursorPosition != currentText.characters.count {
            updateButtonStatus()
            return true
        }
        
        var newString = "\(currentText)\(string)"
        if string.isEmpty {
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92 && cursorPosition == newString.characters.count) {
                newString = newString.substring(to: newString.index(before: newString.endIndex))
            } else {
                updateButtonStatus()
                return true
            }
        }
        textField.text = newString
        updateButtonStatus()
        return false
    }
    
}
