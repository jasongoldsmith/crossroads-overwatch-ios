//
//  ApplicationManager.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import XCGLogger
import SlideMenuControllerSwift

class ApplicationManager: NSObject {
    // Shared Instance
    static let sharedInstance = ApplicationManager()
    
    //XCGLogger Instance
    let log = XCGLogger.default

    //Event Info Objet
    lazy var eventsList: [EventInfo] = []

    //Rating Event
    var ratingInfo: RatingAppModel?

    //Event Info Objet
    lazy var eventsListActivity: [ActivityInfo] = []

    //My Future Events
    lazy var myFutureEvents: [ActivityInfo] = []
    
    //My Current Events
    lazy var myCurrentEvents: [ActivityInfo] = []

    //Activity List
    lazy var activityList: [ActivityInfo] = []

    //Branch Manager
    var branchManager: BranchManager?

    // Error Notification View
    var errorNotificationView = ErrorNotificationView()
    
    //Push Notification Controller (Active State)
    var pushNotiController: PushNotiController?

    //Current User
    var currentUser: UserInfo?

    //Total Users
    var totalUsers: Int?

    // unVerified Prompt
    var verificationPrompt = VerificationPromptView()

    // Invitation Info
    var invitation: InvitationInfo?

    //APP Configuration
    var appConfiguration: ConfigInfo?

    // SlideMenu Controller
    var slideMenuController = SlideMenuController()

    //Bungie Groups
    lazy var groups: [GroupInfo] = []

    // FireBase Manager
    var fireBaseManager: FireBaseManager?

    //Push Notification View Array
    var pushNotificationViewArray: [PushNotificationView] = []

    // MARK:- Initializer
    private override init() {
        super.init()
        //Init FireBase Manager
        self.fireBaseManager = FireBaseManager()
        
        //Init Branch Manager
        self.branchManager = BranchManager()

        // Init Error Notification View with nib
        self.errorNotificationView = Bundle.main.loadNibNamed("ErrorNotificationView", owner: self, options: nil)?[0] as! ErrorNotificationView

        //Init Push Notification Controller (Active State)
        self.pushNotiController = PushNotiController()

        // Notification Observer
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(ApplicationManager.didReceiveRemoteNotificationInActiveSesion),
                                                         name: NSNotification.Name(rawValue: K.NOTIFICATION_TYPE.REMOTE_NOTIFICATION_WITH_ACTIVE_SESSION),
                                                         object: nil)
    }

    // Rewrite this method- User Server Login Response to save userID, psnID, UserImage -- ASHU
    func getPlayerObjectForCurrentUser () -> PlayerInfo? {
        for event in self.eventsList {
            for player in event.eventPlayersArray {
                if player.playerID == UserInfo.getUserID() {
                    return player
                }
            }
        }
        
        return nil
    }

    func purgeSavedData () {
        self.eventsList.removeAll()
        self.eventsListActivity.removeAll()
    }

    func didReceiveRemoteNotificationInActiveSesion(sender: NSNotification) {
        let pushInfo = ActiveStatePushInfo()
        pushInfo.parsePushNotificationPayLoad(sender: sender)
        self.pushNotiController?.showActiveNotificationView(pushInfo: pushInfo, isExistingPushView: false)
    }

    func addSlideMenuController(parentViewController: BaseViewController, pushData: NSDictionary?, branchData:NSDictionary?, showLandingPage: Bool, showGroups: Bool) {
        
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_PROFILE) as! ProfileViewController
        let eventListViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_EVENT_LIST) as! EventListViewController
        let getGroupsViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CHOOSE_GROUP) as! ChooseGroupViewController
        getGroupsViewController.delegate = eventListViewController

        self.slideMenuController = SlideMenuController(mainViewController:eventListViewController, leftMenuViewController: profileViewController, rightMenuViewController: getGroupsViewController)
        self.slideMenuController.automaticallyAdjustsScrollViewInsets = true
        self.slideMenuController.closeRight()
        self.slideMenuController.closeLeft()
        self.slideMenuController.rightPanGesture?.isEnabled = true
        self.slideMenuController.leftPanGesture?.isEnabled = true
        
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            self.slideMenuController.changeLeftViewWidth(290)
            self.slideMenuController.changeRightViewWidth(290)
        } else {
            self.slideMenuController.changeLeftViewWidth(340)
            self.slideMenuController.changeRightViewWidth(340)
        }
        
        SlideMenuOptions.leftBezelWidth = 0.0
        SlideMenuOptions.rightBezelWidth = 0.0
        
        var animated = false
        if let _ = pushData {
            if let _ = pushData!.object(forKey: "payload") as? NSDictionary {
                animated = true
            }
        }
        
        
        self.slideMenuController.view.alpha = 0
        parentViewController.present(self.slideMenuController, animated: animated, completion: {
            
            if let _ = pushData {
                UIApplication.shared.applicationIconBadgeNumber = 0
                self.slideMenuController.view.alpha = 0.7
                self.fetchGroups(openSliderMenu: false, completion: { (didSucceed) in
                    self.slideMenuController.view.alpha = 1
                    eventListViewController.updateGroupImage()
                })
                
                if let payload = pushData!.object(forKey: "payload") as? NSDictionary{
                    let _ = PushNotification().fetchEventFromPushNotification(pushPayLoad: payload, complete: { (event) in
                        if let _ = event {
                            eventListViewController.showEventInfoViewController(eventInfo: event, fromPushNoti: true)
                        }
                    })
                }
            } else if ((branchData) != nil) {
                self.slideMenuController.view.alpha = 0.7
                self.fetchGroups(openSliderMenu: false, completion: { (didSucceed) in
                    self.slideMenuController.view.alpha = 1
                    eventListViewController.updateGroupImage()
                })
                
                let eventID = branchData!["eventId"] as? String
                let activityName = branchData!["activityName"] as? String
                
                eventListViewController.fetchEventDetailForDeepLink(eventID: eventID!, activityName: activityName!)
            } else {
                //Fetch Events
                
                self.slideMenuController.view.alpha = 0.6
                self.fetchGroups(openSliderMenu: false, completion: { (didSucceed) in
                    self.slideMenuController.view.alpha = 1
                    eventListViewController.updateGroupImage()
                })
            }
        })
    }

    func addPostActionbranchDeepLink (eventID: String, activityName: String, params: [AnyHashable : Any]?) {
        
        if var currentView = UIApplication.topViewController() {
            
            if currentView is RootViewController == true {
                let rootViewController = UIApplication.shared.delegate?.window!!.rootViewController as! RootViewController
                rootViewController.branchLinkData = params as NSDictionary?
            } else if currentView is SlideMenuController {
                
                currentView = currentView as! SlideMenuController
                let slideVewController = currentView as! SlideMenuController
                let eventListView = slideVewController.mainViewController! as? EventListViewController
                
                if ApplicationManager.sharedInstance.slideMenuController.isLeftOpen() {
                    let leftView = ApplicationManager.sharedInstance.slideMenuController.leftViewController as! ProfileViewController
                    leftView.dismissViewController(isAnimated: false, dismissed: { (didDismiss) in
                        eventListView!.fetchEventDetailForDeepLink(eventID: eventID, activityName: activityName)
                    })
                } else if (ApplicationManager.sharedInstance.slideMenuController.isRightOpen()) {
                    let rightView = ApplicationManager.sharedInstance.slideMenuController.rightViewController as! ChooseGroupViewController
                    rightView.dismissViewController(isAnimated: false, dismissed: { (didDismiss) in
                        eventListView!.fetchEventDetailForDeepLink(eventID: eventID, activityName: activityName)
                    })
                } else {
                    eventListView!.fetchEventDetailForDeepLink(eventID: eventID, activityName: activityName)
                }
            } else {
                currentView.dismiss(animated: false, completion: {
                    if let _ = self.slideMenuController.mainViewController {
                        let eventListView = self.slideMenuController.mainViewController as! EventListViewController
                        eventListView.fetchEventDetailForDeepLink(eventID: eventID, activityName: activityName)
                    }
                })
            }
        }
    }

    func fetchGroups (openSliderMenu: Bool, completion: @escaping TRValueCallBack) {
        let groupsRequest = GroupsRequest()
        groupsRequest.getGroups(completion: { (didSucceed) in
            guard let succeed = didSucceed else {
                return
            }
            if succeed {
                if openSliderMenu == true {
                    self.slideMenuController.rightViewController!.openRight()
                }
                
                completion(true)
            }
        })
    }

    func addUnVerifiedUserPromptWithDelegate (delegate: VerificationPopUpProtocol?) {
        self.verificationPrompt = Bundle.main.loadNibNamed("VerificationPromptView", owner: self, options: nil)?[0] as! VerificationPromptView
        
        self.verificationPrompt.addVerificationPromptViewWithDelegate(delegate: delegate)
    }
    
    func removeUnVerifiedUserPrompt  () {
        self.verificationPrompt.removeVerificationPromptView()
    }

    //Filter Current Events
    func getCurrentEvents () -> [EventInfo] {
        let currentInfo = self.eventsList.filter{$0.isFutureEvent == false}
        return currentInfo
    }
    
    //Filter Future Events
    func getFutureEvents () -> [EventInfo] {
        let futureInfo = self.eventsList.filter{$0.isFutureEvent == true}
        return futureInfo
    }
    
    // Filter Activity Array Based on ActivityType
    func getActivitiesOfType (activityType: String) -> [ActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activityType == activityType}
        return activityArray
    }
    
    func getActivitiesMatchingSubTypeAndLevel(activity: ActivityInfo) -> [ActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activitySubType == activity.activitySubType && $0.activityDificulty == activity.activityDificulty}
        
        var removeDuplicateArray: [ActivityInfo] = []
        for (_, activity) in activityArray.enumerated() {
            if (removeDuplicateArray.count < 1) {
                removeDuplicateArray.append(activity)
            } else {
                let activityArray = removeDuplicateArray.filter {$0.activityCheckPoint == activity.activityCheckPoint}
                if (activityArray.count == 0) {
                    removeDuplicateArray.append(activity)
                }
            }
        }
        
        return removeDuplicateArray
    }
    
    func getActivitiesMatchingSubTypeAndLevelAndCheckPoint(activity: ActivityInfo) -> [ActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activitySubType == activity.activitySubType && $0.activityDificulty == activity.activityDificulty && $0.activityCheckPoint == activity.activityCheckPoint
        }
        
        return activityArray
    }
    
    func getFeaturedActivities () -> [ActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activityIsFeatured == true}
        return activityArray
    }
    
    func getCurrentGroup (groupID: String) -> GroupInfo? {
        let currentGroupArray = self.groups.filter {$0.groupId == groupID}
        return currentGroupArray.first
    }

    
    func getGroupByGroupId (groupId: String) -> GroupInfo? {
        let groupsArray = ApplicationManager.sharedInstance.groups.filter{$0.groupId == groupId}
        return groupsArray.first
    }
    
    func getEventById (eventId: String) -> EventInfo? {
        
        let eventObjectArray = ApplicationManager.sharedInstance.eventsList.filter{$0.eventID == eventId}
        return eventObjectArray.first
    }
    
    func isCurrentPlayerInAnEvent (event: EventInfo) -> Bool {
        
        let found = event.eventPlayersArray.filter {$0.playerID == UserInfo.getUserID()}
        if found.count > 0 {
            return true
        }
        
        return false
    }
    
    func isCurrentPlayerCreatorOfTheEvent (event: EventInfo) -> Bool {
        if event.eventCreator?.playerID == UserInfo.getUserID() {
            return true
        }
        
        return false
    }
    
    func addErrorSubViewWithMessage(errorString: String) {
        self.errorNotificationView.errorSting = errorString
        self.errorNotificationView.addErrorSubViewWithMessage()
    }
    
    //console type from string
    func getConsoleTypeFrom(consoleString:String) -> String? {
        let possibleConsoles = ["PC", "PlayStation 4", "Xbox One"]
        if let theIndex = possibleConsoles.index(of: consoleString) {
            switch theIndex {
            case 0:
                return "pc"
            case 1:
                return "ps4"
            case 2:
                return "xboxone"
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getConsoleNameFrom(consoleType:String) -> String? {
        let possibleConsoles = ["pc", "ps4", "xboxone"]
        if let theIndex = possibleConsoles.index(of: consoleType.lowercased()) {
            switch theIndex {
            case 0:
                return "PC"
            case 1:
                return "PlayStation 4"
            case 2:
                return "Xbox One"
            default:
                return nil
            }
        } else {
            return nil
        }
    }

}
