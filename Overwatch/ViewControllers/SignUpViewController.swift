//
//  SignUpViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/24/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import TTTAttributedLabel

class SignUpViewController: LoginBaseViewController, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var legalLabel: TTTAttributedLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Legal Statement
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            legalLabel.font = UIFont(name: legalLabel.font.fontName, size: 10.0)
        }
        self.addLegalStatmentText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func nextButtonPressed() {
        guard let email = emailTextField.text,
        let password = passwordTextField.text,
        email.isValidEmail,
        password.isValidPassword else {
            return
        }
        //ChoosePlatformViewController
        let signupRequest = SignUpRequest()
        signupRequest.signUpWith(email: email, and: password, completion: { (value) -> () in
            if let wrappedValue = value,
                wrappedValue == true {
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "choosePlatformViewController") as! ChoosePlatformViewController
                self.navigationController?.pushViewController(vc, animated: true)
                self.view.endEditing(true)
            } else {
                print("Something went wrong signing up")
            }
        })
    }

    func addLegalStatmentText () {
        let legalString = "By clicking the “Next” button below, I have read and agree to\nthe Crossroads Terms of Service and Privacy Policy."
        
        let customerAgreement = "Terms of Service"
        let privacyPolicy = "Privacy Policy"
        
        self.legalLabel.text = legalString
        
        // Add HyperLink to Bungie
        let nsString = legalString as NSString
        
        let rangeCustomerAgreement = nsString.range(of: customerAgreement)
        let rangePrivacyPolicy = nsString.range(of: privacyPolicy)
        let urlCustomerAgreement = NSURL(string: "https://www.crossroadsapp.co/terms")!
        let urlPrivacyPolicy = NSURL(string: "https://www.crossroadsapp.co/privacy")!
        
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 188/255, green: 197/255, blue: 225/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(value:true),
            ]
        self.legalLabel.linkAttributes = subscriptionNoticeLinkAttributes
        self.legalLabel.addLink(to: urlCustomerAgreement as URL!, with: rangeCustomerAgreement)
        self.legalLabel.addLink(to: urlPrivacyPolicy as URL!, with: rangePrivacyPolicy)
        self.legalLabel.adjustsFontSizeToFitWidth = true
        self.legalLabel.delegate = self
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
//        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
//        let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
//        legalViewController.linkToOpen = url
//        self.presentViewController(legalViewController, animated: true, completion: {
//
//        })
    }
}
