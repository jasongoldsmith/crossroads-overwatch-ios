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


class LoginBaseViewController: BaseViewController {
    
    @IBOutlet weak var BottomNextButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        Key Board Observer
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction override func navBackButtonPressed(sender: UIBarButtonItem?) {
        //    override func navBackButtonPressed(sender: UIBarButtonItem?) {
        if let navController = navigationController {
            navController.popViewController(animated: true)
            navController.navigationBar.isHidden = true
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
    }
    
    func dismissView() {
        dismissViewController(isAnimated: true, dismissed: { (didDismiss) in
            
        })
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [String : AnyObject] = sender.userInfo! as! [String : AnyObject]
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue.size
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
}
