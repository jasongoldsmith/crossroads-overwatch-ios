//
//  TRChangePasswordViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/18/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var oldPasswordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var passwordUpdatedLabel: UILabel!
    @IBOutlet weak var oldEmailView: UIView!
    @IBOutlet weak var newEmailView: UIView!
    @IBOutlet weak var oldEmail: UITextField!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var sendButtonBottonConst: NSLayoutConstraint!
    
    @IBOutlet weak var changeEmailTextLabel: UILabel!
    @IBOutlet weak var changepasswordTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)

        // Placeholder Strings
        let textColor = UIColor(red: 188/255, green: 197/255, blue: 255/255, alpha: 1)
        self.oldPassword.attributedPlaceholder = NSAttributedString(string:"Enter current password", attributes: [NSForegroundColorAttributeName: textColor])
        self.newPassword.attributedPlaceholder = NSAttributedString(string:"Enter new password", attributes: [NSForegroundColorAttributeName: textColor])
        self.oldEmail.attributedPlaceholder = NSAttributedString(string:"Enter current email address", attributes: [NSForegroundColorAttributeName: textColor])
        self.newEmail.attributedPlaceholder = NSAttributedString(string:"Enter new email address", attributes: [NSForegroundColorAttributeName: textColor])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        
        if self.oldPassword?.isFirstResponder == true {
            self.oldPassword?.resignFirstResponder()
        } else {
            self.newPassword?.resignFirstResponder()
        }
        
        self.dismissViewController(isAnimated: true) { (didDismiss) in
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.oldPassword) {
            self.newPassword.becomeFirstResponder()
        } else {
            self.saveButtonPressed()
        }
        return true
    }
    
    @IBAction func textFieldDidBecomeActive (sender: UITextField) {
        
    }
    
    @IBAction func textFieldDidDidUpdate (textField: UITextField) {
        if (textField.text?.characters.count)! >= 4 {
            self.saveButton.isEnabled = true
            self.saveButton.backgroundColor = UIColor(red: 148/255, green: 123/255, blue: 67/255, alpha: 1)
        } else {
            self.saveButton.isEnabled = false
            self.saveButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
        }
    }
    
    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [String : AnyObject] = sender.userInfo! as! [String : AnyObject]
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.cgRectValue.size
        
        if keyboardSize.height == offset.height {
            
            if self.oldPassword.isFirstResponder == true || self.newPassword.isFirstResponder == true {
                if self.sendButtonBottonConst?.constant == 0 {
                    UIView.animate(withDuration: 0.4, animations: { () -> Void in
                        self.sendButtonBottonConst?.constant -= keyboardSize.height
                        self.view.frame.origin.y = 0
                    })
                }
            } else {
                self.sendButtonBottonConst?.constant = 0.0
                if self.view.frame.origin.y == 0 {
                    UIView.animate(withDuration: 0.4, animations: { () -> Void in
                        self.view.frame.origin.y -= keyboardSize.height
                    })
                }
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [String : AnyObject] = sender.userInfo! as! [String : AnyObject]
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue.size
        
        if self.view.frame.origin.y == self.view.frame.origin.y - keyboardSize.height {
            self.view.frame.origin.y += keyboardSize.height
        }
        else {
            self.sendButtonBottonConst?.constant = 0
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func saveButtonPressed () {
        
        let oldPasswordEmpty = self.oldPassword.text?.isEmpty
        let newPasswordEmpty = self.newPassword.text?.isEmpty
        let oldEmailEmpty = self.oldEmail.text?.isEmpty
        let newEmailEmpty = self.newEmail.text?.isEmpty
        
        if newPasswordEmpty == false && oldPasswordEmpty == true {
            //ApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter old password.")
            
            return
        } else if newPasswordEmpty == true && oldPasswordEmpty == false {
            //ApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter new password.")
            
            return
        }else if newEmailEmpty == false && oldEmailEmpty == true {
            //ApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter old email address.")
            
            return
        }else if newEmailEmpty == true && oldEmailEmpty == false {
            //ApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter new email address.")
            
            return
        }
        
        if self.oldPassword.text?.isEmpty == false && self.newPassword.text?.isEmpty == false {
            // Change Password
            let _ = UpdateUser().updateUserPassword(newPassword: self.newPassword?.text, oldPassword: self.oldPassword?.text) { (didSucceed) in
                
                if didSucceed == true {
                    
                    let defaults = UserDefaults.standard
                    defaults.setValue(self.newPassword?.text, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
                    defaults.synchronize()
                    
                    self.oldEmailView?.isHidden = true
                    self.newEmailView?.isHidden = true
                    self.oldPasswordView?.isHidden = true
                    self.newPasswordView?.isHidden = true
                    self.changeEmailTextLabel?.isHidden = true
                    self.changepasswordTextLabel?.isHidden = true
                    self.saveButton.isEnabled = false
                    self.saveButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
                    self.passwordUpdatedLabel?.isHidden = false
                    
                    self.resignKeyBoard()
                }
            }
        } else {
            //Change email id
            let _ = UpdateUser().updateUserEmail(newEmail: self.newEmail?.text, oldEmail: self.oldEmail?.text) { (didSucceed) in
                
                if didSucceed == true {
                    
                    let defaults = UserDefaults.standard
                    defaults.setValue(self.newPassword?.text, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
                    defaults.synchronize()
                    
                    self.oldEmailView?.isHidden = true
                    self.newEmailView?.isHidden = true
                    self.oldPasswordView?.isHidden = true
                    self.newPasswordView?.isHidden = true
                    self.changeEmailTextLabel?.isHidden = true
                    self.changepasswordTextLabel?.isHidden
                        = true
                    self.saveButton.isEnabled = false
                    self.saveButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
                    
                    self.passwordUpdatedLabel?.isHidden = false
                    self.passwordUpdatedLabel?.text = "Email Updated."
                    
                    //Close KeyBoard
                    self.resignKeyBoard()
                }
            }
        }
    }
    
    @IBAction func showPasswordClicked () {
        if let _ = self.newPassword.text, self.newPassword.text?.isEmpty != true {
            let tmpString = self.newPassword?.text
            self.newPassword.isSecureTextEntry = !self.newPassword.isSecureTextEntry
            self.newPassword?.text = ""
            self.newPassword?.text = tmpString
        }
    }
    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        self.resignKeyBoard()
    }
    
    func resignKeyBoard () {
        if self.newPassword?.isFirstResponder == true {
            self.newPassword?.resignFirstResponder()
        } else if self.oldPassword?.isFirstResponder == true{
            self.oldPassword?.resignFirstResponder()
        } else if self.oldEmail?.isFirstResponder == true{
            self.oldEmail?.resignFirstResponder()
        } else {
            self.newEmail?.resignFirstResponder()
        }
    }
    
    deinit {
        
    }
}
