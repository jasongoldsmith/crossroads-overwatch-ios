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

    @IBAction func showHideNewPassword() {
        newPasswordTextField.isSecureTextEntry = !newPasswordTextField.isSecureTextEntry
    }

    @IBAction func saveButtonPressed() {
        guard let oldPassword = passwordTextField.text,
            let newPassword = newPasswordTextField.text,
            newPassword.isValidPassword,
            oldPassword.isValidPassword else {
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
                print("Something went wrong updating the user Email")
            }
        })
    }
}
