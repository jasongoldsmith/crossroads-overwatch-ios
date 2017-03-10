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
        view.endEditing(true)
        let subject = "Forgot password"
        var body = ""
        if let email = emailTextField.text,
            email.isValidEmail {
            body = "This is my email address.\n\(email)"
        }
        guard let urlString = "mailto:support@crossroadsapp.co?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let emailURL = URL(string:urlString) else {
                return
        }
        if UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: ["":""], completionHandler: nil)
        }
    }

    @IBAction func resetPasswordButtonPressed() {
        guard let email = emailTextField.text,
            email.isValidEmail else {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessage(errorString: "Please enter a valid email address")
                return
        }
        view.endEditing(true)
        let resetPassword = ForgotPasswordRequest()
        resetPassword.resetUserPassword(userEmail: email, completion: { (error, responseObject) -> () in
            if let _ = responseObject {
                let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CONTACT_MESSAGE_SENT) as! MessageSentConfViewController
                vc.email = email
                if let navController = self.navigationController {
                    navController.pushViewController(vc, animated: true)
                } else {
                    self.present(vc, animated: true, completion: nil)
                }
            } else if let wrappedError = error {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessage(errorString: wrappedError)
            } else {
                print("Something went wrong updating the user Email")
            }
        })
    }

    //Overriding the methods
    override func areTheFieldsValid() -> Bool {
        if let email = emailTextField.text,
            email.isValidEmail {
            return true
        }
        return false
    }

    
    //UITextFieldDelegate Delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if areTheFieldsValid() {
            resetPasswordButtonPressed()
        }
        return true
    }
}
