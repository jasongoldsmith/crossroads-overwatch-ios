//
//  ProfileViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/17/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import TTTAttributedLabel
import UIKit
import SlideMenuControllerSwift

class ProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TTTAttributedLabelDelegate {
    
    
    @IBOutlet weak var avatorImageView: UIImageView?
    @IBOutlet weak var avatorUserName: UILabel?
    @IBOutlet weak var backGroundImageView: UIImageView?
    @IBOutlet weak var buildNumberLabel: UILabel!
    @IBOutlet weak var legalLabel: TTTAttributedLabel!
    
    //Console Buttons/ Image
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    var consoleTwoButton: UIButton?
    var consoleAddButton: UIButton?
    var currentUser: PlayerInfo?
    var isConsoleMenuOpen: Bool = false
    var consoleAddButtonImageView: UIImageView?
    var consoleTwoButtonImageView: UIImageView?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Update build number
        self.addVersionAndLegalAttributedLabel()
        
        //Add Radius to buttons
        self.changePasswordButton.layer.cornerRadius = 2.0
        self.contactUsButton.layer.cornerRadius = 2.0
        self.logOutButton.layer.cornerRadius = 2.0
        self.updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.backGroundImageView?.clipsToBounds = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.isConsoleMenuOpen = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addVersionAndLegalAttributedLabel () {
        
        let messageString = "\(Bundle.main.releaseVersionNumber!) (\(Bundle.main.buildVersionNumber!))"
        self.buildNumberLabel.text = messageString
        
        
        let legalMessageString = "Terms of Service | Privacy Policy | Licenses"
        self.legalLabel.text = legalMessageString
        
        let tos = "Terms of Service"
        let privatePolicy = "Privacy Policy"
        let licenses = "Licenses"
        
        let nsString = legalMessageString as NSString
        let tosRange = nsString.range(of: tos)
        let privateRange = nsString.range(of: privatePolicy)
        let licenseRange = nsString.range(of: licenses)
        
        let tosUrl = NSURL(string: "https://www.crossroadsapp.co/terms")!
        let privatePolicyUrl = NSURL(string: "https://www.crossroadsapp.co/privacy")!
        let licensesUrl = NSURL(string: "https://www.crossroadsapp.co/license")!
        
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSUnderlineStyleAttributeName: NSNumber(value:true),
            ]
        
        self.legalLabel.linkAttributes = subscriptionNoticeLinkAttributes
        self.legalLabel.addLink(to: tosUrl as URL!, with: tosRange)
        self.legalLabel.addLink(to: privatePolicyUrl as URL!, with: privateRange)
        self.legalLabel.addLink(to: licensesUrl as URL!, with: licenseRange)
        self.legalLabel.delegate = self
    }
    
    func updateView () {
        
        self.currentUser = ApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()
        
        // User Image
        self.updateUserAvatorImage()
        
        self.avatorUserName?.text = UserInfo.getUserName()
    }
    
    func updateUserAvatorImage () {
        
        //Avator for Current Player
        if UserInfo.isUserVerified()! != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
            self.avatorImageView?.image = UIImage(named: "avatar")
        } else {
            if let imageUrlString = UserInfo.getUserImageString() {
                if imageUrlString != "",
                    let imageUrl = URL(string: imageUrlString) {
                    avatorImageView?.sd_setImage(with: imageUrl)
                }
            }
        }
    }
    
    
    @IBAction func inviteFriends () {
        
        let url: String = "https://crossrd.app.link/share"
        let groupToShare = [url as AnyObject] as [AnyObject]
        
        let activityViewController = UIActivityViewController(activityItems: groupToShare , applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    
    @IBAction func logOutUser () {
        self.addLogOutAlert()
    }
    
    @IBAction func backButtonPressed (sender: AnyObject) {
        ApplicationManager.sharedInstance.slideMenuController.closeRight()
    }
    
    
    @IBAction func changePassword (sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : ChangePasswordViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CHANGE_PASSWORD) as! ChangePasswordViewController

        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.isHidden = true
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func sendReport () {
//        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
//        let vc : TRSendReportViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as! TRSendReportViewController
//        
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.navigationBar.hidden = true
//        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
//        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
//        let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
//        legalViewController.linkToOpen = url
//        self.presentViewController(legalViewController, animated: true, completion: {
//            
//        })
    }
    
    
    //MOVE THIS TO ANOTHER CLASS LATER
    func addLogOutAlert () {
        let refreshAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//            let createRequest = TRAuthenticationRequest()
//            createRequest.logoutTRUser() { (value ) in
//                if value == true {
//                    
//                    self.dismissViewControllerAnimated(false, completion:{
//                        TRUserInfo.removeUserData()
//                        TRApplicationManager.sharedInstance.purgeSavedData()
//                        
//                        self.didMoveToParentViewController(nil)
//                        self.removeFromParentViewController()
//                    })
//                    
//                    self.presentingViewController?.dismissViewControllerAnimated(false, completion: {
//                        TRUserInfo.removeUserData()
//                        TRApplicationManager.sharedInstance.purgeSavedData()
//                        
//                        self.didMoveToParentViewController(nil)
//                        self.removeFromParentViewController()
//                    })
//                } else {
//                    self.displayAlertWithTitle("Logout Failed", complete: { (complete) -> () in
//                    })
//                }
//            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
}

