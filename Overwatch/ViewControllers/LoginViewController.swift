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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func forgotPassword() {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "forgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextButtonPressed() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email.isValidEmail,
            password.isValidPassword else {
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
}
