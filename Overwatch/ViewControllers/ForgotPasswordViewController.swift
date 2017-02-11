//
//  ForgotPasswordViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/25/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ForgotPasswordViewController: LoginBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
        
    @IBAction func resetPassword() {
        if let email = emailTextField.text,
            email.isValidEmail {
            view.endEditing(true)
            let subject = "Forgot password"
            let body = "This is my email address.\n\(email)"
            guard let urlString = "mailto:support@crossroadsapp.co?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let emailURL = URL(string:urlString) else {
                    return
            }
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: ["":""], completionHandler: nil)
            }
        }
    }

    @IBAction func resetPasswordButtonPressed() {
        if let email = emailTextField.text,
            email.isValidEmail {
            view.endEditing(true)
            let resetPassword = ForgotPasswordRequest()
            resetPassword.resetUserPassword(userEmail: email, completion: { (error, responseObject) -> () in
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
}
