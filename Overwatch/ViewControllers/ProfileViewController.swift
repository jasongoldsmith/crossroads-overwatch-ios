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

class ProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TTTAttributedLabelDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var avatorImageView: UIImageView?
    @IBOutlet weak var avatorUserName: UILabel?
    @IBOutlet weak var backGroundImageView: UIImageView?
    @IBOutlet weak var buildNumberLabel: UILabel!
    @IBOutlet weak var legalLabel: TTTAttributedLabel!
    @IBOutlet weak var consolesTable: UITableView!
    @IBOutlet weak var currentConsoleLabel: UILabel!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    //Console Buttons/ Image
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    var consoleTwoButton: UIButton?
    var consoleAddButton: UIButton?
    var currentUser: PlayerInfo?
    var isConsoleMenuOpen: Bool = true
    var isAddingConsoles = false
    var firstEntry = true
    var consoleAddButtonImageView: UIImageView?
    var consoleTwoButtonImageView: UIImageView?
    var consoles = [String]()
    var currentConsole = ""
    
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
        consoleButtonPressed()
        consolesTable.register(UINib(nibName: "ConsoleProfileCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backGroundImageView?.clipsToBounds = true
        if isAddingConsoles || firstEntry {
            isAddingConsoles = false
            firstEntry = false
            let profileRequest = ProfileRequest()
            profileRequest.getProfile(completion: { (profileDidSucceed) in
                if let profileSucceed = profileDidSucceed,
                    profileSucceed {
                    self.updateView()
                }
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isConsoleMenuOpen == true {
            consoleButtonPressed()
        }
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
        
        let tosUrl = URL(string: "https://www.crossroadsapp.co/terms")!
        let privatePolicyUrl = URL(string: "https://www.crossroadsapp.co/privacy")!
        let licensesUrl = URL(string: "https://www.crossroadsapp.co/license")!
        
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSUnderlineStyleAttributeName: NSNumber(value:true),
            ]
        
        self.legalLabel.linkAttributes = subscriptionNoticeLinkAttributes
        self.legalLabel.addLink(to: tosUrl, with: tosRange)
        self.legalLabel.addLink(to: privatePolicyUrl, with: privateRange)
        self.legalLabel.addLink(to: licensesUrl, with: licenseRange)
        self.legalLabel.delegate = self
    }
    
    func updateView () {
        consoles.removeAll()
        self.currentUser = ApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()
        //consoles
        if let defaultConsole = ApplicationManager.sharedInstance.currentUser?.getDefaultConsole()?.consoleType {
            currentConsole = defaultConsole
            currentConsoleLabel.text = currentConsole
        }
        if let savedConsoles = ApplicationManager.sharedInstance.currentUser?.consoles {
            if savedConsoles.count != 3 {
                consoles.append("Linked Accounts")
            }
            for console in savedConsoles {
                if let consoleType = console.consoleType,
                    currentConsole != consoleType {
                    consoles.insert(consoleType, at: 0)
                }
            }
        }
        // User Image
        self.updateUserAvatorImage()
        
        self.avatorUserName?.text = UserInfo.getUserName()
        self.consolesTable.reloadData()
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

        let navigationController = BaseNavigationViewController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func sendReport () {
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as!
        SendReportViewController
        let navigationController = BaseNavigationViewController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }

    @IBAction func consoleButtonPressed() {
        if tableHeightConstraint.constant == 0 {
            if consoles.count > 1 {
                tableHeightConstraint.constant = 90
            } else {
                tableHeightConstraint.constant = 47
            }
            isConsoleMenuOpen = true
        } else {
            tableHeightConstraint.constant = 0
            isConsoleMenuOpen = false
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }

    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let legalViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as!
        LegalViewController
        legalViewController.linkToOpen = url
        self.present(legalViewController, animated: true, completion: {
        })
    }
    
    //MOVE THIS TO ANOTHER CLASS LATER
    func addLogOutAlert () {
        let refreshAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let logoutRequest = LogOutRequest()
            logoutRequest.logoutUser(completion: {(value ) in
                if let wrappedValue = value,
                    wrappedValue {
                    UserInfo.removeUserData()
                    ApplicationManager.sharedInstance.purgeSavedData()
                    DispatchQueue.main.async {
                        ApplicationManager.sharedInstance.slideMenuController.dismiss(animated: false, completion:{
                            UserInfo.removeUserData()
                            ApplicationManager.sharedInstance.purgeSavedData()
                        })
                    }
                }
            })
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    

    //Table View Data Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consoles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ConsoleCell
        cell.consoleTitle.text = consoles[indexPath.row]
        return cell
    }
    
    //Table View Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if ApplicationManager.sharedInstance.currentUser?.consoles.count != 3,
            indexPath.row == consoles.count - 1 {
            isAddingConsoles = true
            let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "choosePlatformViewController") as! ChoosePlatformViewController
            vc.comingFromProfile = true
            let navigationController = BaseNavigationViewController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            changePrimaryConsole(consoleType: consoles[indexPath.row].lowercased())
        }
    }
    
    func changePrimaryConsole (consoleType:String) {
        let changeConsole = ChangeConsoleRequest()
        //First Change Console
        changeConsole.changeConsole(consoleType: consoleType, completion: { (didSucceed) in
            if let succeed = didSucceed,
                succeed {
                //Second FetchGroups
                let groupsRequest = GroupsRequest()
                groupsRequest.getGroups(completion: { (didSucceed) in
                    //Try to take a group with more events
                    if let group = self.bestGroupOption() {
                        //Third Change Group
                        let updateGroupRequest = UpdateGroupRequest()
                        updateGroupRequest.updateUserGroup(groupID: group.groupId!, groupName:group.groupName!, groupImage: group.avatarPath! ,completion: { (didSucceed) in
                            //Fourth Get Feed
                            let feedRequest = FeedRequest()
                            feedRequest.getPrivateFeed(completion: { (didSucceed) in
                                guard let succeed = didSucceed else {
                                    return
                                }
                                if succeed {
                                    let sliderView = ApplicationManager.sharedInstance.slideMenuController
                                    if let eventView = sliderView.mainViewController as? EventListViewController {
                                        eventView.reloadEventTable()
                                        eventView.updateUserAvatorImage()
                                        self.updateView()
                                    }
                                }
                            })
                        })
                    }
                })
            }
        })
    }

    func bestGroupOption() -> GroupInfo? {
        var aGroup:GroupInfo?
        if let firstGroup = ApplicationManager.sharedInstance.groups.first {
            aGroup = firstGroup
            for group in ApplicationManager.sharedInstance.groups {
                guard let iteratedGroupEvents = group.eventCount,
                    let aGroupEvents = aGroup?.eventCount else {
                        continue
                }
                if iteratedGroupEvents > aGroupEvents {
                    aGroup = group
                }
            }
        }
        return aGroup
    }
}

