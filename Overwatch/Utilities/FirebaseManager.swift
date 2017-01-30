//
//  FirebaseManager.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/25/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class FireBaseManager {
    
    var ref: FIRDatabaseReference?
    var userObserverHandler: FIRDatabaseHandle?
    var eventListObserverHandler: FIRDatabaseHandle?
    var eventDescriptionObserverHandler: FIRDatabaseHandle?
    var eventDescriptionCommentObserverHandler: FIRDatabaseHandle?
    
    
    typealias TRFireBaseSuccessCallBack = (_ didCompelete: Bool?) -> ()
    
    //Initialize FireBase Configuration
    func initFireBaseConfig () {
        FIRApp.configure()
    }
    
    
    //MARK:- ADD FIREBASE OBSERVERS
    func addUserObserverWithCompletion (complete: @escaping TRFireBaseSuccessCallBack) {
        if let userID = UserInfo.getUserID() {
            let endPointKeyReference = userID
            self.ref = FIRDatabase.database().reference().child("users/").child(endPointKeyReference)
            self.userObserverHandler = self.ref?.observe(.value, with: { (snapshot) in
                
                if let snap = snapshot.value as? NSDictionary {
                    let userData = UserInfo()
                    let snapShotJson = JSON(snap)
                    userData.parseUserResponse(responseObject: snapShotJson)
                    
                    for console in userData.consoles {
                        if console.isPrimary == true {
                            UserInfo.saveConsolesObject(consoleObj: console)
                        }
                    }
                    
                    UserInfo.saveUserData(userData: userData)
                    
                    // Check if user is VERIFIED and if it is then remove the observer
                    if (UserInfo.isUserVerified() == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                        self.removeUserObserver()
                    }
                    
                    complete(true)
                }
            })
        }
    }
    
    func addUserObserverWithView (complete: @escaping TRFireBaseSuccessCallBack) {
        if let userID = UserInfo.getUserID() {
            let endPointKeyReference = userID
            self.ref = FIRDatabase.database().reference().child("users/").child(endPointKeyReference)
            self.userObserverHandler = self.ref?.observe(.value, with: { (snapshot) in
                
                if let snap = snapshot.value as? NSDictionary {
                    let userData = UserInfo()
                    let snapShotJson = JSON(snap)
                    userData.parseUserResponse(responseObject: snapShotJson)
                    
                    for console in userData.consoles {
                        if console.isPrimary == true {
                            UserInfo.saveConsolesObject(consoleObj: console)
                        }
                    }
                    
                    UserInfo.saveUserData(userData: userData)
                    complete(true)
                }
            })
        }
    }
    
    func addEventsObserversWithParentView (parentViewController: BaseViewController) {
        guard let userClan = ApplicationManager.sharedInstance.currentUser?.userClanID, userClan != "" else {
            return
        }
        let endPointKeyReference = userClan
        self.ref = FIRDatabase.database().reference().child("events/").child(endPointKeyReference)
        self.eventListObserverHandler = self.ref?.observe(.value, with: { (snapshot) in
            let feedRequest = FeedRequest()
            feedRequest.getPrivateFeed(completion: { (didSucceed) in
                guard let succeed = didSucceed else {
                    return
                }
                if succeed {
                    DispatchQueue.main.async {
                        parentViewController.reloadEventTable()
                    }
                }
            })
        })
    }
    
    func addEventsObserversWithParentViewForDetailView (parentViewController: EventDetailViewController, withEvent: EventInfo) {
        
        guard let hasEventID = withEvent.eventID else {
            return
        }
        
        guard let hasEventClan = withEvent.eventClanID else {
            return
        }
        
        let endPointKeyReference = hasEventClan + "/" + hasEventID
        self.ref = FIRDatabase.database().reference().child("events/").child(endPointKeyReference)
        self.eventDescriptionObserverHandler = self.ref?.observe(.value, with: { (snapshot) in
            if snapshot.value is NSNull {
                parentViewController.dismissViewController(isAnimated: true, dismissed: { (didDismiss) in
                    
                })
                return
            }

            // FETCH EVENT OBJECT
            let eventRequest = GetEventRequest()
            eventRequest.getEvent(hasEventID, completion: { (error, event) in
                if error == nil,
                    let anEvent = event {
                    parentViewController.eventInfo = anEvent
                    DispatchQueue.main.async {
                        parentViewController.reloadEventTable()
                    }
                }
            })
        })
    }
    
    func addCommentsObserversWithParentViewForDetailView (parentViewController: EventDetailViewController, withEvent: EventInfo) {
        
        guard let hasEventID = withEvent.eventID else {
            return
        }
        
        
        let endPointKeyReference = "/" + hasEventID
        self.ref = FIRDatabase.database().reference().child("comments/").child(endPointKeyReference)
        self.eventDescriptionCommentObserverHandler = self.ref?.observe(.value, with: { (snapshot) in
            
            // FETCH EVENT OBJECT
            let eventRequest = GetEventRequest()
            eventRequest.getEvent(hasEventID, completion: { (error, event) in
                if error == nil,
                    let anEvent = event {
                    parentViewController.eventInfo = anEvent
                    DispatchQueue.main.async {
                        parentViewController.reloadEventTable()
                    }
                }
            })

        })
    }
    
    //MARK:- REMOVE FIREBASE OBSERVERS
    func removeUserObserver () {
        if let userID = UserInfo.getUserID() {
            if let _ = self.userObserverHandler {
                let endPointKeyReference = userID
                self.ref = FIRDatabase.database().reference().child("users/").child(endPointKeyReference)
                self.ref?.removeObserver(withHandle: self.userObserverHandler!)
            }
        }
    }
    
    func removeEventListObserver () {
        guard let userClan = ApplicationManager.sharedInstance.currentUser?.userClanID else {
            return
        }
        guard let _ = self.eventListObserverHandler else {
            return
        }
        
        let endPointKeyReference = userClan
        self.ref = FIRDatabase.database().reference().child("events/").child(endPointKeyReference)
        self.ref?.removeObserver(withHandle: self.eventListObserverHandler!)
    }
    
    func removeDetailObserver (withEvent: EventInfo) {
        guard let hasEventClan = withEvent.eventClanID else {
            return
        }
        guard let hasEventID = withEvent.eventID else {
            return
        }
        guard let _ = self.eventDescriptionObserverHandler else {
            return
        }
        
        let endPointKeyReference = hasEventClan + "/" + hasEventID
        self.ref = FIRDatabase.database().reference().child("events/").child(endPointKeyReference)
        self.ref?.removeObserver(withHandle: self.eventDescriptionObserverHandler!)
    }
    
    func removeCommentsObserver (withEvent: EventInfo) {
        
        guard let hasEventClan = withEvent.eventClanID else {
            return
        }
        
        guard let hasEventID = withEvent.eventID else {
            return
        }
        
        let endPointKeyReference = hasEventClan + "/" + hasEventID
        self.ref = FIRDatabase.database().reference().child("comments/").child(endPointKeyReference)
        self.ref?.removeObserver(withHandle: self.eventDescriptionObserverHandler!)
    }
    
    func removeObservers () {
        self.ref?.removeAllObservers()
    }
}
