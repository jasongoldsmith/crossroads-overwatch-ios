//
//  PushNotiController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/1/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import pop
import SlideMenuControllerSwift

class PushNotiController: NSObject, NotificationViewProtocol {
    
    lazy var eventDetailPushViews: [PushNotificationView] = []
    
    override init () {
    }
    
    func showActiveNotificationView (pushInfo: ActiveStatePushInfo, isExistingPushView: Bool) {
        if var currentView = UIApplication.topViewController() {
            var parentView: UIViewController?
            if currentView is SlideMenuController {
                currentView = (currentView as? SlideMenuController)!
                let slideVewController = currentView as? SlideMenuController
                
                guard let _ = slideVewController else {
                    return
                }
                
                if ApplicationManager.sharedInstance.slideMenuController.isLeftOpen() || ApplicationManager.sharedInstance.slideMenuController.isRightOpen() {
                    return
                } else {
                    if let eventListView = slideVewController?.mainViewController! as? EventListViewController {
                        parentView = eventListView
                    }
                }
            } else {
                let slideVewController = ApplicationManager.sharedInstance.slideMenuController
                if let eventListView = slideVewController.mainViewController! as? EventListViewController {
                    parentView = eventListView
                }
            }
            
            // If Parent View is nil, just return
            guard let _ = parentView else {
                return
            }
            
            let notificationview = self.addActiveNotificationViewWithParentView(pushInfo: pushInfo, parentViewController: parentView as! BaseViewController, isExistingPushView: isExistingPushView)
            
            if isExistingPushView == false {
                notificationview.parentView = parentView as? BaseViewController
                parentView?.view.addSubview(notificationview)
            }
            
            //Add Animation and Move Table Down
            let lastPushView = ApplicationManager.sharedInstance.pushNotificationViewArray.first
            if let _ = lastPushView {
                self.addPushAnimationAndResetTableViewOffSet(notificationview: lastPushView!, parentView: parentView!, isExistingPushView: isExistingPushView)
            }
        }
    }
    
    func addPushAnimationAndResetTableViewOffSet (notificationview: PushNotificationView, parentView: UIViewController, isExistingPushView: Bool) {
        if parentView is EventListViewController {
            let eventView = parentView as! EventListViewController
            eventView.notificationShowMoveTableDown(yOffSet: notificationview.frame.height + 13)
        }
    }
    
    func addActiveNotificationViewWithParentView (pushInfo: ActiveStatePushInfo, parentViewController: BaseViewController, isExistingPushView: Bool) -> PushNotificationView {
        
        let yOffSet = parentViewController is EventListViewController ? CGFloat(145) : CGFloat(190)
        
        if ApplicationManager.sharedInstance.pushNotificationViewArray.count < 1 {
            let notificationview = self.createNotificationViewWithMessages(pushInfo: pushInfo, parentViewController: parentViewController, isExistingPushView: isExistingPushView)
            notificationview.frame = CGRect(x:9, y:yOffSet, width:((UIApplication.topViewController()?.view.frame.size.width)! - 18), height:notificationview.frame.size.height)
            
            return notificationview
        } else {
            let newNotificationview = self.createNotificationViewWithMessages(pushInfo: pushInfo, parentViewController: parentViewController, isExistingPushView: isExistingPushView)
            newNotificationview.frame = CGRect(x:9, y:yOffSet, width:(UIApplication.topViewController()!.view.frame.size.width) - 18, height:newNotificationview.frame.size.height)
            
            if ApplicationManager.sharedInstance.pushNotificationViewArray.count == 1 {
                newNotificationview.eventStatusLabel.text = newNotificationview.pushInfo?.alertString
                return newNotificationview
            } else {
                for notificationView in ApplicationManager.sharedInstance.pushNotificationViewArray where notificationView != ApplicationManager.sharedInstance.pushNotificationViewArray.last  {
                    notificationView.frame = CGRect(x:notificationView.frame.origin.x, y:notificationView.frame.origin.y, width:notificationView.frame.size.width, height:newNotificationview.frame.size.height + 12)
                    
                    
                    let text = notificationView.eventStatusDescription.text
                    let stringLength = text?.characters.count
                    if notificationView.eventStatusDescription.frame.height > 32 {
                        let substringIndex = stringLength! - 70
                        if substringIndex > 15 {
                            let truncated = (text! as NSString).substring(to: substringIndex)
                            notificationView.eventStatusDescription.frame = newNotificationview.eventDescriptionFrame!
                            notificationView.eventStatusDescription.text = truncated
                        }
                    }
                }
            }
            
            return newNotificationview
        }
    }
    
    
    func createNotificationViewWithMessages (pushInfo: ActiveStatePushInfo, parentViewController: BaseViewController, isExistingPushView: Bool) -> PushNotificationView {
        
        //Push Notification View
        var pushNotificationView = PushNotificationView()
        
        // Init Push Notification View with nib
        pushNotificationView = Bundle.main.loadNibNamed("PushNotificationView", owner: self, options: nil)?[0] as! PushNotificationView
        pushNotificationView = pushNotificationView.addNotificationViewWithMessages(pushInfo: pushInfo, parentView:parentViewController)
        pushNotificationView.delegate  = self
        
        if isExistingPushView == false {
            ApplicationManager.sharedInstance.pushNotificationViewArray.append(pushNotificationView)
        }
        
        return pushNotificationView
    }
    
    func activeNotificationViewClosed () {
        
        let topNotificationview = ApplicationManager.sharedInstance.pushNotificationViewArray.last
        
        guard let _ = topNotificationview else {
            return
        }
        
        guard let _ = topNotificationview?.pushInfo else {
            return
        }
        
        var pushNotificationView = PushNotificationView()
        pushNotificationView = Bundle.main.loadNibNamed("PushNotificationView", owner: self, options: nil)?[0] as! PushNotificationView
        pushNotificationView = pushNotificationView.addNotificationViewWithMessages(pushInfo: (topNotificationview?.pushInfo)!, parentView:(topNotificationview?.parentView)!)
        
        topNotificationview!.frame = CGRect(x:(topNotificationview?.frame.origin.x)!, y:(topNotificationview?.frame.origin.y)!, width:(topNotificationview?.frame.width)!, height:pushNotificationView.frame.size.height)
        topNotificationview?.eventStatusDescription.text = (topNotificationview?.pushInfo?.alertString)!
        
        for notificationView in ApplicationManager.sharedInstance.pushNotificationViewArray where notificationView != ApplicationManager.sharedInstance.pushNotificationViewArray.last  {
            notificationView.frame = CGRect(x:notificationView.frame.origin.x, y:notificationView.frame.origin.y, width:notificationView.frame.size.width, height:topNotificationview!.frame.size.height + 8)
        }
        
        //Add Animation and Move Table Down
        let lastPushView = ApplicationManager.sharedInstance.pushNotificationViewArray.first
        if let _ = lastPushView {
            self.addPushAnimationAndResetTableViewOffSet(notificationview: lastPushView!, parentView: pushNotificationView.parentView!, isExistingPushView: true)
        }
    }
    
    func refreshPushViewForParent (parentView: BaseViewController) {
        
    }
    
    // Called when event detail is closed.
    func deleteAllNotificationsWithEventID (eventID: String) {
        
        let eventListView = ApplicationManager.sharedInstance.slideMenuController.mainViewController! as? EventListViewController
        
        // Delete array which stores push views for Event Detail
        self.eventDetailPushViews.removeAll()
        
        var tempPushViewArray:[PushNotificationView] = []
        for (_, pushView) in ApplicationManager.sharedInstance.pushNotificationViewArray.enumerated(){
            let pushEventID = (pushView.pushInfo?.eventID!)! as String
            let eventID = eventID as String
            
            if pushEventID == eventID {
                if pushView.pushInfo?.isMessageNotification == true {
                    pushView.parentView = eventListView
                    tempPushViewArray.append(pushView)
                } else {
                    pushView.closeErrorViewInBackground()
                    pushView.removeFromSuperview()
                }
            } else {
                pushView.parentView = eventListView
                tempPushViewArray.append(pushView)
            }
        }
        
        ApplicationManager.sharedInstance.pushNotificationViewArray.removeAll()
        ApplicationManager.sharedInstance.pushNotificationViewArray = tempPushViewArray
        
        
        for pushViews in ApplicationManager.sharedInstance.pushNotificationViewArray {
            eventListView?.view.addSubview(pushViews)
            
            pushViews.frame = CGRect(x:pushViews.frame.origin.x, y:145, width:pushViews.frame.size.width, height:pushViews.frame.size.height)
            self.showActiveNotificationView(pushInfo: pushViews.pushInfo!, isExistingPushView: true)
        }
        
        if ApplicationManager.sharedInstance.pushNotificationViewArray.count == 0 {
            eventListView!.activeNotificationViewClosed()
        }
    }
    
    func showAllNotificationsWithEventID (eventID: String, parentView: UIViewController) {
        
        self.eventDetailPushViews = ApplicationManager.sharedInstance.pushNotificationViewArray
        for (_, pushView) in self.eventDetailPushViews.enumerated(){
            let pushEventID = (pushView.pushInfo?.eventID!)! as String
            let eventID = eventID as String
            
            if pushEventID == eventID && pushView.pushInfo?.isMessageNotification == true {
                
                let pushNotiView = self.addActiveNotificationViewWithParentView(pushInfo: pushView.pushInfo!, parentViewController: parentView as! BaseViewController, isExistingPushView: true)
                
                pushView.frame = pushNotiView.frame
                self.addPushAnimationAndResetTableViewOffSet(notificationview: pushNotiView, parentView: parentView, isExistingPushView: true)
                pushView.eventStatusDescription.text = pushView.pushInfo?.alertString
                pushView.parentView = parentView as? BaseViewController
                parentView.view.addSubview(pushView)
            }
        }
    }
}
