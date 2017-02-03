//
//  EventListViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/17/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SlideMenuControllerSwift
//import AFDateHelper

private let CURRENT_EVENT_WITH_CHECK_POINT_CELL     = "currentEventCellWithCheckPoint"
private let CURRENT_EVENT_NO_CHECK_POINT_CELL       = "currentEventCellNoCheckPoint"
private let UPCOMING_EVENT_WITH_CHECK_POINT_CELL    = "upcomingEventCellWithCheckPoint"
private let UPCOMING_EVENT_NO_CHECK_POINT_CELL      = "upcomingEventCellNoCheckPoint"
private let EVENT_ACTIVITY_CARD_CELL                = "eventActivityCard"
private let RATE_APP_CARD_CELL                      = "rateApplicationCell"

private let EVENT_TABLE_HEADER_HEIGHT:CGFloat = 10.0

private let EVENT_CURRENT_WITH_CHECK_POINT_CELL_HEIGHT: CGFloat  = 137.0
private let EVENT_CURRENT_NO_CHECK_POINT_CELL_HEIGHT:CGFloat     = 119.0
private let EVENT_UPCOMING_WITH_CHECK_POINT_CELL_HEIGHT:CGFloat  = 150.0
private let EVENT_UPCOMING_NO_CHECK_POINT_CELL_HEIGHT:CGFloat    = 137.0
private let EVENT_ACTIVITY_CELL_HEIGHT:CGFloat                   = 156.0
private let RATE_APP_CELL_HEIGHT:CGFloat                         = 125.0

class EventListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ErrorViewProtocol, VerificationPopUpProtocol {
    
    @IBOutlet var segmentControl: UISegmentedControl?
    @IBOutlet var eventsTableView: UITableView?
    @IBOutlet var segmentOneUnderLine: UIImageView?
    @IBOutlet var segmentTwoUnderLine: UIImageView?
    @IBOutlet var currentPlayerAvatorIcon: UIImageView?
    @IBOutlet var emptyTableBackGround: UIImageView?
    @IBOutlet var playerGroupsIcon: UIImageView?
    @IBOutlet var eventTableTopConstraint: NSLayoutConstraint?
    
    
    //Events Information
    var eventsInfo: [AnyObject] = []
    
    //Activity Cards
    var activityCardsInfo: [ActivityInfo] = []
    
    // Future Events Information
    var futureEventsInfo: [EventInfo] = []
    
    // Pull to Refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(EventListViewController.handleRefresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.segmentControl?.removeBorders()
        
        let boldFont = UIFont(name: "Helvetica-Bold", size: 16.0)
        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName as NSObject : UIColor.white,
            NSFontAttributeName as NSObject : boldFont!,
            ]
        
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, for: .normal)
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, for: .selected)
        
        self.eventsTableView?.register(UINib(nibName: "EventCurrentWithCheckPointCell", bundle: nil), forCellReuseIdentifier: CURRENT_EVENT_WITH_CHECK_POINT_CELL)
        self.eventsTableView?.register(UINib(nibName: "EventCurrentNoCheckPointCell", bundle: nil), forCellReuseIdentifier: CURRENT_EVENT_NO_CHECK_POINT_CELL)
        self.eventsTableView?.register(UINib(nibName: "EventUpcomingWithCheckPointCell", bundle: nil), forCellReuseIdentifier: UPCOMING_EVENT_WITH_CHECK_POINT_CELL)
        self.eventsTableView?.register(UINib(nibName: "EventUpcomingNoCheckPointCell", bundle: nil), forCellReuseIdentifier: UPCOMING_EVENT_NO_CHECK_POINT_CELL)
        self.eventsTableView?.register(UINib(nibName: "EventActivityCardCell", bundle: nil), forCellReuseIdentifier: EVENT_ACTIVITY_CARD_CELL)
        self.eventsTableView?.register(UINib(nibName: "RateAppCell", bundle: nil), forCellReuseIdentifier: RATE_APP_CARD_CELL)
        
        self.eventsTableView?.tableFooterView = UIView(frame: CGRect.zero)
        self.eventsTableView?.addSubview(self.refreshControl)
        
        //Adding Radius to the Current Player Avator
        self.currentPlayerAvatorIcon?.layer.cornerRadius = (self.currentPlayerAvatorIcon?.frame.width)!/2
        
        //Load table
        self.reloadEventTable()
        
        //Add User Avator Image
        self.updateUserAvatorImage()
        
        //Add Group Icon Image
        self.updateGroupImage()
        
        //Add Gestures to Images
        self.addLogOutEventToAvatorImageView()
        
        // Hide Navigation Bar
        self.hideNavigationBar()
        
        // Show No Events View if Events Table is Empty
        self.emptyTableBackGround?.isHidden = self.eventsInfo.count > 0 ? true : false
        
        //Add Notification Permission
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.addNotificationsPermission()
                
        //Is User Verified
        if UserInfo.isUserVerified()! != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
            ApplicationManager.sharedInstance.addUnVerifiedUserPromptWithDelegate(delegate: self)
        }
    }
    
    // Close Verification Prompt and Show Groups
    func showGroups () {
        ApplicationManager.sharedInstance.fetchGroups(openSliderMenu: true, completion: { (didSucceed) in
        })
    }
    
    func showLegalAlert () {
        
        var legalMessage = ""
        var buttonOneTitle: String?
        var buttonTwoTitle: String?
        let buttonOkTitle  = "OK"
        
        if ApplicationManager.sharedInstance.currentUser?.legalInfo?.privacyNeedsUpdate == true && ApplicationManager.sharedInstance.currentUser?.legalInfo?.termsNeedsUpdate == true {
            legalMessage = "Our Terms of Service and Privacy Policy have changed. \n\n By tapping the “OK” button, you agree to the updated Terms of Service and Privacy Policy."
            buttonOneTitle = "Privacy Policy"
            buttonTwoTitle = "Terms of Service"
        } else if (ApplicationManager.sharedInstance.currentUser?.legalInfo?.privacyNeedsUpdate == true) {
            legalMessage = "Our Privacy Policy has changed. \n\n By tapping the “OK” button, you agree to the updated Privacy Policy."
            buttonOneTitle = "   Privacy Policy   "
        } else if (ApplicationManager.sharedInstance.currentUser?.legalInfo?.termsNeedsUpdate == true) {
            legalMessage = "Our Terms of Service have changed. \n\n By tapping the “OK” button, you agree to the updated Terms of Service."
            buttonTwoTitle = "Terms of Service"
        } else {
            return
        }
        
        self.displayAlertWithActionHandler(title: "Update", message: legalMessage, buttonOneTitle: buttonOneTitle ,buttonTwoTitle: buttonTwoTitle, buttonThreeTitle: buttonOkTitle, completionHandler: {complete in
            
            let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            switch complete! {
            case K.Legal.TOS:
                let legalViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! LegalViewController
                legalViewController.linkToOpen = URL(string: "https://www.crossroadsapp.co/terms")!
                self.present(legalViewController, animated: true, completion: nil)
                
                break
            case K.Legal.PP:
                let legalViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! LegalViewController
                legalViewController.linkToOpen = URL(string: "https://www.crossroadsapp.co/privacy")!
                self.present(legalViewController, animated: true, completion: nil)
                break
            case K.Legal.OK:
//                _ = TRRequestUpdateLegalRequest().updateLegalAcceptance({ (didSucceed) in
//                })
                break
            default:
                break
            }
        })
    }
    
    //MARK:- Swipe Gestures Begins
    @IBAction func userSwipedRight (sender: UISwipeGestureRecognizer) {
        self.segmentControl?.selectedSegmentIndex = 0
        self.segmentControlSelection(sender: self.segmentControl!)
    }
    
    @IBAction func userSwipedLeft (sender: UISwipeGestureRecognizer) {
        self.segmentControl?.selectedSegmentIndex = 1
        self.segmentControlSelection(sender: self.segmentControl!)
    }
    
    //MARK:- Swipe Gestures Ends
    
    func updateUserAvatorImage () {
        
        //Avator for Current PlayerJ
        if UserInfo.isUserVerified()! != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
            self.currentPlayerAvatorIcon?.image = UIImage(named:"avatar")
        } else {
            if let imageUrlString = UserInfo.getUserImageString() {
                if imageUrlString != "",
                    let imageUrl = URL(string: imageUrlString) {
                    self.currentPlayerAvatorIcon?.sd_setImage(with: imageUrl)
                }
            }
        }
        
        self.currentPlayerAvatorIcon?.roundRectView(borderWidth: 1.0, borderColor: UIColor.white)
    }
    
    func updateGroupImage () {
        
        self.playerGroupsIcon?.layer.borderColor = UIColor.white.cgColor
        self.playerGroupsIcon?.layer.borderWidth = 1.0
        self.playerGroupsIcon?.layer.borderColor = UIColor.white.cgColor
        self.playerGroupsIcon?.layer.masksToBounds = true
        
        if let currentGroupID = UserInfo.getUserClanID() {
            if let hasCurrentGroup = ApplicationManager.sharedInstance.getCurrentGroup(groupID: currentGroupID) {
                if let imageUrlString = hasCurrentGroup.avatarPath,
                    let imageUrl = URL(string: imageUrlString) {
                    self.playerGroupsIcon?.sd_setImage(with: imageUrl)
                }
            }
        }
        
        if self.playerGroupsIcon?.image == nil {
            self.playerGroupsIcon?.image = UIImage(named: "iconGroupCrossroadsFreelance")
        }
        
        //Remove Observer running on previous clan and add it again on current clan
        ApplicationManager.sharedInstance.fireBaseManager?.removeEventListObserver()
        ApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentView(parentViewController: self)
    }
    
    func addLogOutEventToAvatorImageView () {
        let openLeftGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(EventListViewController.avatorBtnTapped))
        self.currentPlayerAvatorIcon?.isUserInteractionEnabled = true
        self.currentPlayerAvatorIcon?.addGestureRecognizer(openLeftGestureRecognizer)
        
        let openRightGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(EventListViewController.showChangeGroupsVc))
        self.playerGroupsIcon?.isUserInteractionEnabled = true
        self.playerGroupsIcon?.addGestureRecognizer(openRightGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Reload Table
        self.reloadEventTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check if Legal statement has been updated
        self.showLegalAlert()
        
        //Add FireBase Observer
        ApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentView(parentViewController: self)
        
        if ApplicationManager.sharedInstance.pushNotificationViewArray.count == 0 {
            UIView.animate(withDuration: 0.3) {
                self.eventTableTopConstraint?.constant = 11.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove FireBase Observer
        ApplicationManager.sharedInstance.fireBaseManager?.removeEventListObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override  func applicationWillEnterForeground() {
        
        //Add FireBase Observer
        if self.currentViewController is EventListViewController {
            ApplicationManager.sharedInstance.fireBaseManager?.removeEventListObserver()
            ApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentView(parentViewController: self)
        }
    }
    
    
    //MARK:- Table Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.eventsInfo.count > 0 || self.futureEventsInfo.count > 0 || self.activityCardsInfo.count > 0 else {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        
        return EVENT_TABLE_HEADER_HEIGHT
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            return self.eventsInfo.count + self.activityCardsInfo.count
        }
        
        return self.futureEventsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BaseEventTableCell?
        if segmentControl?.selectedSegmentIndex == 0 {
            
            if indexPath.section < self.eventsInfo.count {
                if let eventInfo = self.eventsInfo[indexPath.section] as? EventInfo {
                    if eventInfo.eventActivity?.activityCheckPoint != "" && eventInfo.eventActivity?.activityCheckPoint != nil{
                        cell = tableView.dequeueReusableCell(withIdentifier: CURRENT_EVENT_WITH_CHECK_POINT_CELL) as! EventCurrentWithCheckPointCell
                        if let hasTag = eventInfo.eventActivity?.activityTag, hasTag != ""{
                            self.eventsTableView?.rowHeight = 166.0
                        } else {
                            self.eventsTableView?.rowHeight = EVENT_CURRENT_WITH_CHECK_POINT_CELL_HEIGHT
                        }
                    } else {
                        cell = tableView.dequeueReusableCell(withIdentifier: CURRENT_EVENT_NO_CHECK_POINT_CELL) as! EventCurrentNoCheckPointCell
                        
                        if let hasTag = eventInfo.eventActivity?.activityTag, hasTag != ""{
                            self.eventsTableView?.rowHeight = 153.0
                        } else {
                            self.eventsTableView?.rowHeight = EVENT_CURRENT_NO_CHECK_POINT_CELL_HEIGHT
                        }
                    }
                    
                    cell?.updateCellViewWithEvent(eventInfo: eventInfo)
                    cell?.joinEventButton?.buttonEventInfo = eventInfo
                    cell?.leaveEventButton.buttonEventInfo = eventInfo
                    cell?.eventTimeLabel?.isHidden = true
                } else {
                    let ratingInfo = self.eventsInfo[indexPath.section] as? RatingAppModel
                    let cell = tableView.dequeueReusableCell(withIdentifier: RATE_APP_CARD_CELL) as! RateAppCell
                    self.eventsTableView?.rowHeight = RATE_APP_CELL_HEIGHT
                    let imageURL = URL(string: ratingInfo!.ratingInfoImageURL!)
                    cell.cellBackgroundImage.sd_setImage(with: imageURL)
                    
                    cell.closeButton?.layer.cornerRadius = 2.0
                    cell.actionButton?.layer.cornerRadius = 2.0
                    cell.closeButton?.addTarget(self, action: #selector(EventListViewController.hideRatingRow), for: .touchUpInside)
                    cell.actionButton?.addTarget(self, action: #selector(EventListViewController.ratingButtonClicked), for: .touchUpInside)
                    
                    cell.actionButton.setTitle(ratingInfo!.ratingInfoButtonText, for: .normal)
                    cell.cellTextLabel.text = ratingInfo!.ratingCardText
                    
                    return cell
                }
            } else {
                
                let index = indexPath.section - self.eventsInfo.count
                let cell = tableView.dequeueReusableCell(withIdentifier: EVENT_ACTIVITY_CARD_CELL) as! EventActivityCardCell
                cell.activityInfo = self.activityCardsInfo[index]
                cell.cellActivityAddButton?.buttonActivityInfo = self.activityCardsInfo[index]
                cell.cellActivityAddButton?.addTarget(self, action: #selector(EventListViewController.createActivityWithActivity), for: .touchUpInside)
                self.eventsTableView?.rowHeight = EVENT_ACTIVITY_CELL_HEIGHT
                cell.loadCellView()
                
                return cell
            }
            
        } else {
            
            if self.futureEventsInfo[indexPath.section].eventActivity?.activityCheckPoint != "" && self.futureEventsInfo[indexPath.section].eventActivity?.activityCheckPoint != nil{
                cell = tableView.dequeueReusableCell(withIdentifier: UPCOMING_EVENT_WITH_CHECK_POINT_CELL) as! EventUpcomingWithCheckPointCell
                
                if let hasTag = self.futureEventsInfo[indexPath.section].eventActivity?.activityTag, hasTag != ""{
                    self.eventsTableView?.rowHeight = 180.0
                } else {
                    self.eventsTableView?.rowHeight = EVENT_UPCOMING_WITH_CHECK_POINT_CELL_HEIGHT
                }
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: UPCOMING_EVENT_NO_CHECK_POINT_CELL) as! EventUpcomingNoCheckPointCell
                
                if let hasTag = self.futureEventsInfo[indexPath.section].eventActivity?.activityTag, hasTag != ""{
                    self.eventsTableView?.rowHeight = 166
                } else {
                    self.eventsTableView?.rowHeight = EVENT_UPCOMING_NO_CHECK_POINT_CELL_HEIGHT
                }
            }
            
            
            cell?.updateCellViewWithEvent(eventInfo: self.futureEventsInfo[indexPath.section])
            cell?.joinEventButton?.buttonEventInfo = futureEventsInfo[indexPath.section]
            cell?.leaveEventButton.buttonEventInfo = futureEventsInfo[indexPath.section]
            cell?.eventTimeLabel?.isHidden = false
        }
        
        cell?.joinEventButton?.addTarget(self, action: #selector(EventListViewController.joinAnEvent), for: .touchUpInside)
        cell?.leaveEventButton?.addTarget(self, action: #selector(EventListViewController.leaveAnEvent), for: .touchUpInside)
        cell?.layoutSubviews()
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.eventsTableView?.deselectRow(at: indexPath, animated: false)
        
        let eventInfo: EventInfo!
        if self.segmentControl?.selectedSegmentIndex == 0 {
            if indexPath.section < self.eventsInfo.count {
                eventInfo = self.eventsInfo[indexPath.section] as? EventInfo
                self.showEventInfoViewController(eventInfo: eventInfo, fromPushNoti: false)
            } else {
                
                if let cell = self.eventsTableView?.cellForRow(at: indexPath) as? EventActivityCardCell {
                    if let _ = cell.cellActivityAddButton.buttonActivityInfo {
                        
                        // Tracking Open Source
                        var mySourceDict = [String: AnyObject]()
                        mySourceDict["activityId"] = cell.cellActivityAddButton.buttonActivityInfo?.activityID as AnyObject?
                        
                        //TRACKING
//                        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(mySourceDict, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_ADD_CARD_CLICKED, completion: {didSucceed in
//                            if didSucceed == true {
//                                
//                            }
//                        })
                        
                        self.createActivityWithActivity(sender: cell.cellActivityAddButton)
                    }
                }
            }
        } else {
            eventInfo = self.futureEventsInfo[indexPath.section]
            self.showEventInfoViewController(eventInfo: eventInfo, fromPushNoti: false)
        }

    }
    
    //MARK: RATING UI SELECTORS
    func hideRatingRow () {
        
        self.displayAlertWithTwoButtonsTitleAndMessage(title: "\"Do you have time to explain?\" \n - The Exo Stranger", message: nil, buttonOne: "Definitely", buttonTwo: "Cancel") { (complete) in
            if complete == true {
                let rateAppRequest = RateApplication()
                rateAppRequest.updateRateApplication(ratingStatus: "REFUSED", completion: { (didSucceed) in
                    ApplicationManager.sharedInstance.ratingInfo = nil
                    self.reloadEventTable()
                    
                    let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                    let vc : SendReportViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as! SendReportViewController
                    let navigationController = BaseNavigationViewController(rootViewController: vc)
                    self.present(navigationController, animated: true, completion: nil)
                })
            }
        }
    }
    
    func ratingButtonClicked () {
        
        self.displayAlertWithTwoButtonsTitleAndMessage(title: "\"Tick, tock. Get rolling.\" - Lord Shaxx", message: nil, buttonOne: "Rate Us", buttonTwo: "Cancel") { (complete) in
            if complete == true {
                let rateAppRequest = RateApplication()
                rateAppRequest.updateRateApplication(ratingStatus: "COMPLETED", completion: { (didSucceed) in
                    ApplicationManager.sharedInstance.ratingInfo = nil
                    self.reloadEventTable()
                    
                    UIApplication.shared.open(URL(string: K.TRUrls.TR_APP_STORE_LINK)!, options: ["":""], completionHandler: nil)
                })
            }
        }
    }

    func showEventInfoViewController(eventInfo: EventInfo?, fromPushNoti: Bool?) {
        if let eventId = eventInfo?.eventID {
            let eventRequest = GetEventRequest()
            eventRequest.getEvent(eventId, completion: { (error, event) in
                if error == nil,
                    let anEvent = event {
                    let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                    let vc : EventDetailViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_EVENT_DESCRIPTION) as! EventDetailViewController
                    vc.eventInfo = anEvent
                    self.present(vc, animated: true, completion: nil)
                }
            })
        }
    }
    
    func fetchEventDetailForDeepLink (eventID: String, activityName: String) {
        let eventInfo = ApplicationManager.sharedInstance.getEventById(eventId: eventID)
        if let _ = eventInfo {
            do {
                let _ = try self.getBranchError(eventInfo: eventInfo!)
            } catch let errorType as Branch_Error {
                self.showBranchErrorViewWithError(errorType: errorType, eventInfo: eventInfo, activityName: activityName)
                return
            } catch {
            }
            
            //Deep Link
            self.changeGroupToClickedActivePushNoti(groupId: (eventInfo?.eventClanID)!)
            self.showEventInfoViewController(eventInfo: eventInfo, fromPushNoti: false)
        } else {
            let eventRequest = GetEventRequest()
            eventRequest.getEvent(eventID, completion: { (error, event) in
                if error == nil,
                    let anEvent = event {
                    do {
                        let _ = try self.getBranchError(eventInfo: anEvent)
                    } catch let errorType as Branch_Error {
                        self.showBranchErrorViewWithError(errorType: errorType, eventInfo: anEvent, activityName: activityName)
                        return
                    } catch {
                    }
                    
                    //Deep Link
                    self.changeConsoleToClickActivePushNoti(eventConsole: (anEvent.eventConsoleType)!)
                    self.changeGroupToClickedActivePushNoti(groupId: (anEvent.eventClanID)!)
                    self.showEventInfoViewController(eventInfo: event, fromPushNoti: false)
                } else {
                    if let _ = error {
                        self.showBranchErrorViewWithError(errorType: Branch_Error.ACTIVITY_NOT_AVAILABLE, eventInfo: nil, activityName: activityName)
                    }
                }
            })
        }
    }
    
    func getBranchError (eventInfo: EventInfo) throws {
        //TEST THESE CONDITIONS
        do {
            let _ = try eventInfo.isEventFull()
        } catch _ {
            throw Branch_Error.MAXIMUM_PLAYERS_REACHED
        }
        
        do {
            let _ = try eventInfo.isEventGroupPartOfUsersGroups()
        } catch _ {
            throw Branch_Error.JOIN_BUNGIE_GROUP
        }
        
        do {
            let _ = try eventInfo.isEventConsoleMatchesUserConsole()
        } catch _ {
            throw Branch_Error.NEEDS_CONSOLE
        }
    }
    
    func showBranchErrorViewWithError (errorType: Branch_Error, eventInfo: EventInfo?, activityName: String?) {
        
        DispatchQueue.main.async {
            let errorView = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)?[0] as! ErrorView
            errorView.frame = self.view.frame
            errorView.errorType = errorType
            errorView.delegate = self
            if let _ = eventInfo {
                errorView.eventInfo = eventInfo!
            }
            if let _ = activityName {
                errorView.activityName = activityName
            }
            
            self.view.addSubview(errorView)
        }
    }
    
    //Called when app is in background state
    override func didReceiveRemoteNotificationInBackGroundSession(sender: NSNotification) {
        
        // If Event Info is open, If Navigations are open, close them too
        if let topController = UIApplication.topViewController() {
            if topController is EventListViewController {
                topController.dismiss(animated: false, completion: {
                    topController.didMove(toParentViewController: nil)
                    topController.removeFromParentViewController()
                })
            } else if (topController.navigationController != nil) {
                topController.dismiss(animated: false, completion: {
                })
            }
        }
        
        
        if let payload = sender.userInfo!["payload"] as? NSDictionary {
            let _ = PushNotification().fetchEventFromPushNotification(pushPayLoad: payload, complete: { (event) in
                if let _ = event {
                    self.showEventInfoViewController(eventInfo: event, fromPushNoti: true)
                }
            })
        }
    }
    
    //MARK:- Event Methods
    func joinAnEvent (sender: EventButton) {
        if let eventInfo = sender.buttonEventInfo {
            let joinEventRequest = JoinEventRequest()
            joinEventRequest.joinEventWithUserForEvent(UserInfo.getUserID()!, eventInfo: eventInfo, completion: { (event) in
                if let _ = event {
                    DispatchQueue.main.async {
                        self.reloadEventTable()
                    }
                }
            })
        }
    }
    
    func leaveAnEvent (sender: EventButton) {
        let leaveEventRequest = LeaveEventRequest()
        leaveEventRequest.leaveAnEvent(sender.buttonEventInfo!, completion: { (event) in
            DispatchQueue.main.async {
                self.reloadEventTable()
            }
        })
    }
    
    @IBAction func createAnEvent () {
        
        //TRACKING
//        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_ADD_ACTIVITY_CLICKED, completion: {didSucceed in
//            if didSucceed == true {
//            }
//        })
        
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : CreateEventViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_CREATE_EVENT) as! CreateEventViewController
        let navigationController = BaseNavigationViewController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- Table Refresh
    func handleRefresh(refreshControl: UIRefreshControl) {
        let privateFeedRequest = FeedRequest()
        privateFeedRequest.getPrivateFeed(completion: { (didSucceed) in
            guard let succeed = didSucceed else {
                return
            }
            if succeed {
                refreshControl.endRefreshing()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    DispatchQueue.main.async {
                        self.reloadEventTable()
                    }
                }
            } else {
                ApplicationManager.sharedInstance.log.debug("Failed")
            }
        })
    }
    
    
    
    override func reloadEventTable () {
        
        //Reload Table
        self.eventsInfo       = ApplicationManager.sharedInstance.getCurrentEvents()
        self.futureEventsInfo = ApplicationManager.sharedInstance.getFutureEvents()
        self.activityCardsInfo = ApplicationManager.sharedInstance.eventsListActivity
        
        let contentOffset = self.eventsTableView?.contentOffset
        self.eventsTableView?.reloadData()
        self.eventsTableView?.contentOffset = contentOffset!
    }
    
    @IBAction func segmentControlSelection (sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.segmentOneUnderLine?.isHidden = false
            self.segmentTwoUnderLine?.isHidden = true
            self.emptyTableBackGround?.isHidden = self.eventsInfo.count > 0 ? true : false
            
            //TRACKING
//            _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SEG_CURRENT_CLICKED, completion: {didSucceed in
//                if didSucceed == true {
//                }
//            })
            
            
            break;
        case 1:
            self.segmentOneUnderLine?.isHidden = true
            self.segmentTwoUnderLine?.isHidden = false
            self.emptyTableBackGround?.isHidden = self.futureEventsInfo.count > 0 ? true : false
            
            //TRACKING
//            _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SEG_UPCOMING_CLICKED, completion: {didSucceed in
//                if didSucceed == true {
//                }
//            })
            
            break;
        default:
            break;
        }
        
        //Reload Data
        DispatchQueue.main.async {
            self.reloadEventTable()
        }
    }
    
    //MARK:- OTHER VIEW-CONTROLLERS
    func avatorBtnTapped(sender: AnyObject) {
        ApplicationManager.sharedInstance.slideMenuController.openLeft()
    }
    
    @IBAction func showChangeGroupsVc (sender: AnyObject) {
        ApplicationManager.sharedInstance.fetchGroups(openSliderMenu: true, completion: { (didSucceed) in
        })
    }
    
    func createActivityWithActivity (sender: EventButton) {
        self.createActivityFromEvent(sender: sender.buttonActivityInfo!)
    }
    
    func createActivityFromEvent (sender: ActivityInfo) {
        if let activityType =  sender.activityType {
            let createEventRequest = CreateEventRequest()
            createEventRequest.getTheListEvents(with: activityType, completion: { (didSucceed) in
                guard let succeed = didSucceed else {
                    return
                }
                if succeed {
                    let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                    let vc : CreateEventFinalView = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CREATE_EVENT_FINAL) as! CreateEventFinalView
                    vc.activityInfo = ApplicationManager.sharedInstance.activityList
                    vc.selectedActivity = sender
                    let navigationController = BaseNavigationViewController(rootViewController: vc)
                    self.present(navigationController, animated: true, completion: nil)
                }
            })
        }
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let numberOfSections = self.eventsTableView!.numberOfSections
            let numberOfRows = self.eventsTableView!.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.eventsTableView?.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }

    }
    
    
    //MARK:- NOTIFICATION VIEW PROTOCOL
    func notificationShowMoveTableDown (yOffSet: CGFloat) {
        
        UIView.animate(withDuration: 0.3) {
            self.eventTableTopConstraint?.constant = yOffSet
            self.view.layoutIfNeeded()
        }
    }
    
    override func activeNotificationViewClosed () {
        
        if ApplicationManager.sharedInstance.pushNotificationViewArray.count == 0 {
            UIView.animate(withDuration: 0.3) {
                self.eventTableTopConstraint?.constant = 11.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func showEventDetailView (eventID: String) {
        
        let eventInfo = ApplicationManager.sharedInstance.getEventById(eventId: eventID)
        if let _ = eventInfo {
            self.changeGroupToClickedActivePushNoti(groupId: (eventInfo?.eventClanID)!)
            self.showEventInfoViewController(eventInfo: eventInfo, fromPushNoti: false)
        } else {
            let eventRequest = GetEventRequest()
            eventRequest.getEvent(eventID, completion: { (error, event) in
                if error == nil,
                    let anEvent = event {
                    self.changeConsoleToClickActivePushNoti(eventConsole: (anEvent.eventConsoleType)!)
                    self.changeGroupToClickedActivePushNoti(groupId: (anEvent.eventClanID)!)
                    self.showEventInfoViewController(eventInfo: anEvent, fromPushNoti: false)
                }
            })
        }
    }
    
    func changeGroupToClickedActivePushNoti (groupId: String) {
        
        if let selectedGroup = ApplicationManager.sharedInstance.getGroupByGroupId(groupId: groupId) {
            let updateGroupRequest = UpdateGroupRequest()
            updateGroupRequest.updateUserGroup(groupID: selectedGroup.groupId!, groupName: (selectedGroup.groupName)!, groupImage: (selectedGroup.avatarPath)!, completion: { (didSucceed) in
                let feedRequest = FeedRequest()
                feedRequest.getPrivateFeed(completion: { (didSucceed) in
                    guard let succeed = didSucceed else {
                        return
                    }
                    if succeed {
                        self.reloadEventTable()
                        self.updateGroupImage ()
                    }
                })
            })
        }
    }
    
    func changeConsoleToClickActivePushNoti (eventConsole: String) {
        
        if let console = ApplicationManager.sharedInstance.currentUser?.getDefaultConsole() {
            if console.consoleType == eventConsole {
                return
            } else {
                let consoleArray = ApplicationManager.sharedInstance.currentUser?.consoles.filter{$0.consoleType == eventConsole}
                if let existingConsole = consoleArray?.first {
                    let changeConsoleRequest = ChangeConsoleRequest()
                    changeConsoleRequest.changeConsole(consoleType: existingConsole.consoleType!, completion: { (didSucceed) in
                        let feedRequest = FeedRequest()
                        feedRequest.getPrivateFeed(completion: { (didSucceed) in
                            guard let succeed = didSucceed else {
                                return
                            }
                            if succeed {
                                self.reloadEventTable()
                                self.updateGroupImage ()
                            }
                        })
                    })
                } else {
                    return
                }
            }
        }
    }

    //MARK:- Error Message View Handling actions
    func addActivity (eventInfo: EventInfo?) {
        if let _ = eventInfo?.eventActivity {
            self.createActivityFromEvent(sender: (eventInfo?.eventActivity)!)
        }
    }
    
    func addConsole () {
        
    }
        
    func closeEventListView () {
        self.dismissViewController(isAnimated: true) { (didDismiss) in
            
        }
    }
    
    //MARK:- deinit
    deinit {
        self.eventsInfo.removeAll()
        self.futureEventsInfo.removeAll()
        self.activityCardsInfo.removeAll()
        
        //Remove Observer
        NotificationCenter.default.removeObserver(self)
        
        ApplicationManager.sharedInstance.log.debug("de-init")
    }
}

