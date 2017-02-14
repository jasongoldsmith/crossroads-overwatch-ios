//
//  ChangeEmailViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ChangeEmailViewController: LoginBaseViewController {
    
    @IBOutlet weak var currentEmailAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentEmail = ApplicationManager.sharedInstance.currentUser?.email {
            let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 195/255, blue: 0/255, alpha: 1)]
            let countAttributedStr = NSAttributedString(string: "\n\(currentEmail)", attributes: stringColorAttribute)
            let helpAttributedStr = NSAttributedString(string: "Current email address:", attributes: nil)
            let finalString:NSMutableAttributedString = helpAttributedStr.mutableCopy() as! NSMutableAttributedString
            finalString.append(countAttributedStr)
            
            currentEmailAddress.attributedText = finalString
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }

    @IBAction func saveButtonPressed() {
        guard let email = emailTextField.text,
            email.isValidEmail else {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessage(errorString: "Please enter a valid email address")
                return
        }
        guard let password = passwordTextField.text,
            password.isValidPassword else {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessage(errorString: "Please enter a valid password, it must contain at least 4 charaters")
                return
        }
        view.endEditing(true)
        let changeEmailRequest = ChangeEmailRequest()
        changeEmailRequest.updateUserEmail(password: password, newEmail: email, completion: { (error, responseObject) -> () in
            if let _ = responseObject {
                let profileRequest = ProfileRequest()
                profileRequest.getProfile(completion: { (profileDidSucceed) in
                    guard let profileSucceed = profileDidSucceed else {
                        return
                    }
                    if profileSucceed {
                        self.navBackButtonPressed(sender: nil)
                    }
                })
            } else if let wrappedError = error {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessageFromDictionaryString(dictionaryString: wrappedError)
            } else {
                print("Something went wrong updating the user Email")
            }
        })
    }

    //UITextFieldDelegate Delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if areTheFieldsValid() {
            saveButtonPressed()
        } else {
            if textField == emailTextField {
                passwordTextField.becomeFirstResponder()
            } else if textField == passwordTextField {
                emailTextField.becomeFirstResponder()
            }
        }
        return true
    }
}
