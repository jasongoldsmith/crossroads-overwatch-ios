//
//  ChooseGroupViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel
import SlideMenuControllerSwift

private let GROUP_CELLS_IDENTIFIER = "groupCells"
private let MIN_DEFAULT_GROUPS = 0

class ChooseGroupViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate {
    
    private var groups: [GroupInfo] = []
    private var selectedGroup: GroupInfo?
    private var highlightedCell: GroupCell?
    
    var delegate: AnyObject?
    
    //To be hidden if there are no groups
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var lableOne: UILabel!
    @IBOutlet weak var lableThree: TTTAttributedLabel!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    //Selected Group View
    @IBOutlet weak var selectedGroupView: UIView!
    @IBOutlet weak var selectedGroupViewGroupImage: UIImageView!
    @IBOutlet weak var selectedGroupViewGroupName: UILabel!
    @IBOutlet weak var selectedGroupViewMemberCount: UILabel!
    @IBOutlet weak var selectedGroupViewEventCount: UILabel!
    @IBOutlet weak var selectedGroupViewNotificationButton: EventButton!
    
    //UnVerified User's View
    @IBOutlet weak var unVerifiedUserView: UIView!
    @IBOutlet weak var unVerifiedUserLabel: TTTAttributedLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupsTableView?.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: GROUP_CELLS_IDENTIFIER)
        
        self.lableOne?.text = "Region"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Fetch Groups
        self.groups.removeAll()
        self.groups = ApplicationManager.sharedInstance.groups
        
        if ApplicationManager.sharedInstance.groups.count <=  1 {
            //self.addNoneGroupCountUI()
            self.lableThree.isHidden = true
        } else {
            self.saveButton.setTitle(nil, for: .normal)
            self.lableThree.isHidden = true
            //Add bottom border to GroupList Table
            
            self.changeSaveButtonVisuals()
        }
        
        if let userGroup = UserInfo.getUserClanID() {
            let selectedGroup = self.groups.filter{$0.groupId! == userGroup}
            self.selectedGroup = selectedGroup.first
            let groupIndex = self.groups.index(where: {$0.groupId == self.selectedGroup?.groupId})
            if let _ = groupIndex {
                self.groups.remove(at: groupIndex!)
            }
            
            //Add selected Group UI
            DispatchQueue.main.async {
                if let _ = self.selectedGroup {
                    self.addSelectedGroupUI()
                }
            }
        }
        
        // Reload Data
        DispatchQueue.main.async {
            UIView.transition(with: self.groupsTableView,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                      animations:
                { () -> Void in
                    self.groupsTableView.reloadData()
                    self.groupsTableView.setContentOffset(CGPoint.zero, animated:true)
            },
                                      completion: nil);
        }
        
        if UserInfo.isUserVerified()! != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
            self.addNonVerifiedUserUI()
        } else {
            self.removeNonVerifiedUserUI()
        }
    }
    
    func changeSaveButtonVisuals () {
        self.saveButton?.isEnabled = false
        self.saveButton?.titleLabel?.text = nil
        self.saveButton?.backgroundColor = UIColor(red: 35/255, green: 58/255, blue: 62/255, alpha: 1)
        
        self.saveButton.layer.shadowColor = UIColor.black.cgColor;
        self.saveButton.layer.shadowOffset = CGSize(width:3, height:3);
        self.saveButton.layer.shadowRadius = 5;
        self.saveButton.layer.shadowOpacity = 1;
    }
    
    func addSelectedGroupUI () {
        
        //Add rounder corner radius to the view
        self.selectedGroupView.cornerRadius = 2.0
        
        if let hasImage = self.selectedGroup?.avatarPath,
            let imageUrl = URL(string: hasImage) {
            self.selectedGroupViewGroupImage?.sd_setImage(with: imageUrl)
        }
        
        self.selectedGroupViewGroupName.text = self.selectedGroup?.groupName
        self.selectedGroupViewMemberCount.text = (self.selectedGroup?.memberCount?.description)! + " in Queue"
        self.selectedGroupViewNotificationButton.isSelected = self.selectedGroup?.groupNotification == true ? true: false
        self.selectedGroupViewNotificationButton.addTarget(self, action: #selector(updateNotificationPreference), for: .touchUpInside)
        self.selectedGroupViewNotificationButton.buttonGroupInfo = self.selectedGroup
        
        if let eventCount = self.selectedGroup?.eventCount {
            let activity = eventCount == 1 ? " Activity" : " Activities"
            self.selectedGroupViewEventCount.text = eventCount.description + activity
        } else {
            self.selectedGroupViewEventCount.isHidden = true
        }
        
        if let eventMembers = self.selectedGroup?.memberCount {
            self.selectedGroupViewMemberCount.text = eventMembers.description + " in Queue"
        } else {
            self.selectedGroupViewMemberCount.isHidden = true
        }
        
        
    }
    
    
    //MARK- Scroll Methods
    // Help to disable/ enable scroll in down-right direction. Disabling helps to let table view scroll and to let swipe gesture be disabled
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("Scroll")
        ApplicationManager.sharedInstance.slideMenuController.rightPanGesture?.isEnabled = false
    }
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        ApplicationManager.sharedInstance.slideMenuController.rightPanGesture?.isEnabled = true
    }
    
    func addNonVerifiedUserUI () {
        self.unVerifiedUserView.isHidden = false
        
        let messageString = "To play with other groups and update your profile, please verify your account. \n\n Check your messages on Battle.net for a verification link from Crossroads."
        let bungieLinkName = "Battle.net"
        self.unVerifiedUserLabel?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.range(of: bungieLinkName)
        let url = NSURL(string: "https://www.battle.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(value:true),
            ]
        self.unVerifiedUserLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.unVerifiedUserLabel.addLink(to: url as URL!, with: range)
        self.unVerifiedUserLabel?.delegate = self
        
        self.saveButton.isEnabled = true
        self.saveButton?.isHidden = false
        self.saveButton.setTitle("VERIFY ON BATTLE.NET", for: .normal)
        self.saveButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
    }
    
    func removeNonVerifiedUserUI () {
        self.unVerifiedUserView.removeFromSuperview()
    }
    
    func addNoneGroupCountUI () {
        self.lableThree.isHidden = true
        
        let messageString = "It looks like you are not a member of any groups. Feel free to Freelance with us or head to Battle.net to join a group and fully experience the Crossroads for Overwatch app."
        let bungieLinkName = "Battle.net"
        self.lableThree?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.range(of: bungieLinkName)
        let url = NSURL(string: "https://www.battle.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(value:true),
            ]
        self.lableThree?.linkAttributes = subscriptionNoticeLinkAttributes
        self.lableThree.addLink(to: url as URL!, with: range)
        self.lableThree?.delegate = self
    }
    
    //MARK:- Table Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if groups.count <= 0 {
            return 1
        }
        
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GROUP_CELLS_IDENTIFIER) as! GroupCell
        if indexPath.section < self.groups.count {
            let groupInfo = self.groups[indexPath.section]
            cell.selectionStyle = .none
            cell.updateCellViewWithGroup(groupInfo: groupInfo)
            cell.isUserInteractionEnabled = true
            cell.notificationButton.buttonGroupInfo = groupInfo
            cell.notificationButton.addTarget(self, action: #selector(updateNotificationPreference), for: .touchUpInside)
            cell.notificationButton.isSelected = groupInfo.groupNotification == true ? true: false
        } else {
            cell.isUserInteractionEnabled = false
            cell.addNoGroupCellUI()
            cell.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedGroup = self.groups[indexPath.section]
        
        let cell = tableView.cellForRow(at: indexPath) as? GroupCell
        self.highlightedCell = cell
        
        if let group = self.selectedGroup {
            let updateGroupRequest = UpdateGroupRequest()
            updateGroupRequest.updateUserGroup(groupID: group.groupId!, groupName:(self.selectedGroup?.groupName)!, groupImage: (self.selectedGroup?.avatarPath)! ,completion: { (didSucceed) in
                let feedRequest = FeedRequest()
                feedRequest.getPrivateFeed(completion: { (didSucceed) in
                    guard let succeed = didSucceed else {
                        return
                    }
                    if succeed {
                        if let del = self.delegate as? EventListViewController {
                            del.reloadEventTable()
                            del.updateGroupImage ()
                        }
                        ApplicationManager.sharedInstance.slideMenuController.closeRight()
                    }
                })
            })
        }
    }
    
    //MARK:- UpdateNotification Request
    func updateNotificationPreference(sender: EventButton) {
        
        if let hasGroupId = sender.buttonGroupInfo?.groupId {
            if let notificationValue = sender.buttonGroupInfo?.groupNotification {
                let groupNotificationUpdateRequest = GroupNotificationUpdateRequest()
                groupNotificationUpdateRequest.updateUserGroupNotification(groupID: hasGroupId, muteNoti: !notificationValue, completion: { (didSucceed) in
                    if let succeed = didSucceed,
                        succeed {
                        DispatchQueue.main.async {
                            if hasGroupId == self.selectedGroup?.groupId {
                                self.selectedGroupViewNotificationButton.isSelected = self.selectedGroup?.groupNotification == true ? true: false
                            } else {
                                self.groupsTableView.reloadData()
                            }
                        }
                    }
                })
            }
        }
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.open(url, options: ["":""], completionHandler: nil)
    }
    
    @IBAction func goToBungieWebSite (sender: UIButton) {
        let url = URL(string: "https://www.battle.net/")!
        UIApplication.shared.open(url, options: ["":""], completionHandler: nil)
    }
    
    @IBAction func showUnVerifiedView (sender: UITapGestureRecognizer) {
        ApplicationManager.sharedInstance.addUnVerifiedUserPromptWithDelegate(delegate: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    deinit {
        
    }
}
