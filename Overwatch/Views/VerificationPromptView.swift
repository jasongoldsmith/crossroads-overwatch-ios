//
//  VerificationPromptView.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/17/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import TTTAttributedLabel


@objc protocol VerificationPopUpProtocol {
    @objc optional func showGroups ()
}


class VerificationPromptView: UIView, TTTAttributedLabelDelegate {
    
    var delegate: VerificationPopUpProtocol?
    
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var startOneLabel: UILabel!
    @IBOutlet weak var startTwoLabel: UILabel!
    @IBOutlet weak var startThreeLabel: UILabel!
    @IBOutlet weak var bungieButton: UIButton!
    @IBOutlet weak var bungieAttLabel: TTTAttributedLabel!
    
    func addVerificationPromptViewWithDelegate (delegate: VerificationPopUpProtocol?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        self.frame = (window?.frame)!
        window?.addSubviewWithLayoutConstraint(newView: self)
        
        if let _ = delegate {
            self.delegate = delegate
        }
        
        self.updateView()
    }
    
    @IBAction func removeVerificationPromptView () {
        if let _ = self.delegate {
            self.delegate!.showGroups!()
            self.delegate = nil
        }
        
        self.removeFromSuperview()
    }
    
    func updateView () {
        
        self.bungieButton?.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        self.userNameView?.layer.cornerRadius = 2.0
        
        var userName = UserInfo.getConsoleID()
        if var clanTag = ApplicationManager.sharedInstance.currentUser?.getDefaultConsole()?.unverDisplayClanTag, clanTag != "" {
            clanTag = " " + "[" + clanTag + "]"
            userName = userName! + clanTag
        }
        
        self.userNameLabel?.text = userName
        self.userImage.roundRectView()
        
        
        if let playerImageString = ApplicationManager.sharedInstance.currentUser?.userImageURL,
            let playerImageURL = URL(string: playerImageString) {
            self.userImage.sd_setImage(with: playerImageURL, placeholderImage: UIImage(named: "avatar"))

        }
        
        self.bungieButton?.layer.cornerRadius = 2.0
        
        self.startOneLabel?.text = "\u{02726}"
        self.startTwoLabel?.text = "\u{02726}"
        self.startThreeLabel?.text = "\u{02726}"
        
        //Attributed Label
        let messageString = "Check your messages on Battle.net for a verification link."
        let bungieLinkName = "Battle.net"
        self.bungieAttLabel?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.range(of: bungieLinkName)
        let url = NSURL(string: "https://www.battle.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(value:true),
            ]
        self.bungieAttLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.bungieAttLabel.addLink(to: url as URL!, with: range)
        self.bungieAttLabel?.delegate = self
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.open(url, options: ["":""], completionHandler: nil)
    }
    
    func goToBungie () {
        let url = NSURL(string: "https://www.battle.net/")!
        UIApplication.shared.open(url as URL, options: ["":""], completionHandler: nil)
    }
    
    @IBAction func bungieButtonAction () {
        self.goToBungie()
    }
}

