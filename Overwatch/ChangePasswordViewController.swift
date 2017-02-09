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
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "onBoardingErrorViewController") as! OnBoardingErrorViewController
                vc.errorString = wrappedError
                self.navigationController?.pushViewController(vc, animated: true)
                self.view.endEditing(true)
            } else {
                print("Something went wrong updating the user Email")
            }
        })
    }
}
