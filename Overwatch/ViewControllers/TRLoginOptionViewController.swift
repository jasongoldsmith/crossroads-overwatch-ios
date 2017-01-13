//
//  TRLoginOptionViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import iCarousel
import TTTAttributedLabel


class TRLoginOptionViewController: TRBaseViewController, iCarouselDataSource, iCarouselDelegate, TTTAttributedLabelDelegate, CustomErrorDelegate {
    
    
    var items: [TREventInfo] = TRApplicationManager.sharedInstance.eventsList
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var carousel : iCarousel!
    @IBOutlet weak var legalLabel: TTTAttributedLabel!
    @IBOutlet weak var playStationButton: UIButton!
    @IBOutlet weak var xBoxButton: UIButton!
    @IBOutlet weak var crossRdLogo: UIImageView!
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var playerCountLabelTopConst: NSLayoutConstraint!
    @IBOutlet weak var crossRdLogoTopConst: NSLayoutConstraint!
    @IBOutlet weak var crossRdLogoWidthConst: NSLayoutConstraint!
    @IBOutlet weak var crossRdLogoHeightConst: NSLayoutConstraint!
    @IBOutlet weak var crossRdLogoCenterConst: NSLayoutConstraint!
    
    @IBOutlet weak var bottomBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var signInLebelBottomConst: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countString = TRApplicationManager.sharedInstance.totalUsers?.description
        let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)]
        var countAttributedStr = NSAttributedString(string: countString!, attributes: stringColorAttribute)
        let helpAttributedStr = NSAttributedString(string: " Guardians searching for Fireteams:", attributes: nil)
        
        if TRApplicationManager.sharedInstance.totalUsers < 1 {
            countAttributedStr = NSAttributedString(string: "", attributes: nil)
        }

        let finalString:NSMutableAttributedString = countAttributedStr.mutableCopy() as! NSMutableAttributedString
        finalString.appendAttributedString(helpAttributedStr)

        self.playerCountLabel.attributedText = finalString
        self.carousel?.autoscroll = -0.1
        
        //Legal Statement
        self.addLegalStatmentText()
        
        //Button Images
        self.playStationButton.setImage(UIImage(named: "pSNLogo"), forState: .Normal)
        self.xBoxButton.setImage(UIImage(named: "xboxLiveLogo"), forState: .Normal)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let isUserLoggedIn = TRUserInfo.isUserLoggedIn()
        if userDefaults.boolForKey(K.UserDefaultKey.FORCED_LOGOUT_NEW_SIGN_IN) == false && isUserLoggedIn == true {
            let errorView = NSBundle.mainBundle().loadNibNamed("TRCustomError", owner: self, options: nil)[0] as! TRCustomError
            errorView.errorMessageHeader?.text = "CHANGES TO SIGN IN"
            errorView.errorMessageDescription?.text = "Good news! You can now sign in using your Xbox or PlayStation account (the same one you use for Bungie.net)"
            errorView.frame = self.view.frame
            errorView.delegate = self
            self.view.addSubview(errorView)
        }
        
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            self.crossRdLogoTopConst?.constant = 90
            self.crossRdLogoWidthConst?.constant = 165
            self.crossRdLogoHeightConst?.constant = 106
            self.playerCountLabelTopConst?.constant  = 6
            self.bottomBtnHeightConst?.constant = 80
            self.signInLebelBottomConst?.constant = 10
            self.crossRdLogoCenterConst?.constant = -1
            
            self.signInLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 11)
//            self.playStationButton?.imageView!.contentMode = .ScaleAspectFill
//            self.xBoxButton.imageEdgeInsets = UIEdgeInsetsMake(10, 25, 10, 25)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }


    func okButtonPressed () {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(true, forKey: K.UserDefaultKey.FORCED_LOGOUT_NEW_SIGN_IN)
    }
    
    @IBAction func xBoxTapped(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRWebViewViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW_SIGNIN) as! TRWebViewViewController
       
        TRApplicationManager.sharedInstance.bungieVarificationHelper.selectedConsoleType = "XBOXONE"
        
        var xBoxLink = ""
        let xboxSavedUrl = NSUserDefaults.standardUserDefaults().objectForKey(K.UserDefaultKey.APPLICATION_CONFIGURATIONS_XBOX_URL) as? String
        if let _ = xboxSavedUrl {
            xBoxLink = xboxSavedUrl!
        }
        
        if let xboxUrl = TRApplicationManager.sharedInstance.appConfiguration!.xBoxLoginUrl {
            xBoxLink = xboxUrl
        }
    
        vc.consoleLoginEndPoint = xBoxLink
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func playStationTapped(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRWebViewViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW_SIGNIN) as! TRWebViewViewController
        vc.consoleLoginEndPoint = "https://www.bungie.net/en/User/SignIn/Psnid"
        
        TRApplicationManager.sharedInstance.bungieVarificationHelper.selectedConsoleType = "PS4"
        
        var psnLink = ""
        let psnSavedUrl = NSUserDefaults.standardUserDefaults().objectForKey(K.UserDefaultKey.APPLICATION_CONFIGURATIONS_PSN_URL) as? String
        if let _ = psnSavedUrl {
            psnLink = psnSavedUrl!
        }
        
        if let psnUrl = TRApplicationManager.sharedInstance.appConfiguration!.psnLoginUrl {
            psnLink = psnUrl
        }
        
        vc.consoleLoginEndPoint = psnLink
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func trUnwindActionToLoginOption(segue: UIStoryboardSegue) {
        
    }
    
    //MARK:- carousel
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return items.count
    }

    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
       
        var itemView: TRCaroselCellView
        
        //create new view if no view is available for recycling
        if (view == nil) {
            itemView = NSBundle.mainBundle().loadNibNamed("TRCaroselCellView", owner: self, options: nil)[0] as! TRCaroselCellView
        } else {
            itemView = view as! TRCaroselCellView
        }
        
        itemView.updateViewWithActivity(items[index])
        return itemView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch (option)
        {
        case .Wrap:
            return 1
        case .Spacing:
            if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
                return value * 1.018
            }
            return value * 1.04
        case .VisibleItems:
            return 3
        default:
            return value
        }
    }
    
    func addLegalStatmentText () {
        let legalString = "By signing in, I have read and agree to the Crossroads Terms of Service and Privacy Policy. © Catalyst Foundry 2016"
        
        let customerAgreement = "Terms of Service"
        let privacyPolicy = "Privacy Policy"
        
        self.legalLabel?.text = legalString
        
        // Add HyperLink to Bungie
        let nsString = legalString as NSString
        
        let rangeCustomerAgreement = nsString.rangeOfString(customerAgreement)
        let rangePrivacyPolicy = nsString.rangeOfString(privacyPolicy)
        let urlCustomerAgreement = NSURL(string: "https://www.crossroadsapp.co/terms")!
        let urlPrivacyPolicy = NSURL(string: "https://www.crossroadsapp.co/privacy")!
        
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        self.legalLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.legalLabel?.addLinkToURL(urlCustomerAgreement, withRange: rangeCustomerAgreement)
        self.legalLabel?.addLinkToURL(urlPrivacyPolicy, withRange: rangePrivacyPolicy)
        self.legalLabel?.delegate = self
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
        legalViewController.linkToOpen = url
        self.presentViewController(legalViewController, animated: true, completion: {
            
        })
    }
}
