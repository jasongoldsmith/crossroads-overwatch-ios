//
//  LoginViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/24/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class LoginViewController: LoginBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    @IBAction func forgotPassword() {
        self.view.endEditing(true)
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "forgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextButtonPressed() {
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
        self.view.endEditing(true)
        let signInRequest = SignInRequest()
        signInRequest.signInWith(email: email, and: password, completion: { (error, responseObject) -> () in
            if let _ = responseObject {
                print("Success signing in")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.validateCookies()
                }
            } else if let wrappedError = error {
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "onBoardingErrorViewController") as! OnBoardingErrorViewController
                vc.errorString = wrappedError
                vc.emailEntered = email
                vc.sourceCode = 2
                vc.passwordEntered = password
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                print("Something went wrong signing in")
            }
        })
    }
    
    func validateCookies() {
        let loginSucceed = !LoginHelper.sharedInstance.shouldShowLoginSceen()
        if !loginSucceed {
            UserInfo.removeUserData()
            ApplicationManager.sharedInstance.purgeSavedData()
            navBackButtonPressed(sender: nil)
        } else {
            dismissView()
        }
    }
    
    
    //UITextFieldDelegate Delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if areTheFieldsValid() {
            nextButtonPressed()
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
