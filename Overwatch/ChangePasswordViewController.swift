//
//  TRChangePasswordViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/18/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class ChangePasswordViewController: LoginBaseViewController {
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }

    @IBAction func showHideNewPassword() {
        let trackingRequest = AppTrackingRequest()
        trackingRequest.sendApplicationPushNotiTracking(notiDict: nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SHOW_PASSWORD, completion: {didSucceed in
        })
        newPasswordTextField.isSecureTextEntry = !newPasswordTextField.isSecureTextEntry
    }

    @IBAction func saveButtonPressed() {
        guard let oldPassword = passwordTextField.text,
            oldPassword.isValidPassword else {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessage(errorString: "Please enter a password with over 4 characters.")
                return
        }
        guard let newPassword = newPasswordTextField.text,
            newPassword.isValidPassword else {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessage(errorString: "Please enter a password with over 4 characters.")
                return
        }

        view.endEditing(true)
        let changePasswordRequest = ChangePasswordRequest()
        changePasswordRequest.updateUserPassword(newPassword: newPassword, oldPassword: oldPassword, completion: { (error, responseObject) -> () in
            if let _ = responseObject {
                self.navBackButtonPressed(sender: nil)
            } else if let wrappedError = error {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessageFromDictionaryString(dictionaryString: wrappedError)
            } else {
                print("Something went wrong updating the user Password")
            }
        })
    }

    override func areTheFieldsValid() -> Bool {
        if let oldPassword = passwordTextField.text,
            let newPassword = newPasswordTextField.text,
            newPassword.isValidPassword,
            oldPassword.isValidPassword {
            return true
        }
        return false
    }
    
    //UITextFieldDelegate Delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if areTheFieldsValid() {
            saveButtonPressed()
        } else {
            if textField == newPasswordTextField {
                passwordTextField.becomeFirstResponder()
            } else if textField == passwordTextField {
                newPasswordTextField.becomeFirstResponder()
            }
        }
        return true
    }
}
