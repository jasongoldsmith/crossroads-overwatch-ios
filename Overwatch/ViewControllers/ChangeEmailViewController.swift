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
    
    @IBAction func saveButtonPressed() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email.isValidEmail,
            password.isValidPassword else {
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
}
