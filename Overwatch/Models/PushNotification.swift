//
//  PushNotification.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

class PushNotification {
    
    var notificationName: String?
    var notificationTrackable: Bool = false
    
    func fetchEventFromPushNotification (pushPayLoad: NSDictionary, complete: @escaping TREventObjCallBack) {
        
        defer {
//            _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(pushPayLoad, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_PUSH_NOTIFICATION, completion: {didSucceed in
//                if didSucceed == true {
//                    
//                }
//            })
        }
        
        if let notiName = pushPayLoad.object(forKey: "notificationName") as? String {
            if notiName == NOTIFICATION_NAME.NOTI_LEAVE.rawValue {
                self.notificationName = NOTIFICATION_NAME.NOTI_LEAVE.rawValue
            }
        }
        
        if let notiTrackable = pushPayLoad.object(forKey: "isTrackable") as? Bool {
            if notiTrackable == true {
                self.notificationTrackable = true
            }
        }
        
        if let eventID = pushPayLoad.object(forKey: "eventId") as? String, eventID != "" {
            if let eventUpdateTime = pushPayLoad.object(forKey: "eventUpdated") as? String {
                if let existingEvent = ApplicationManager.sharedInstance.getEventById(eventId: eventID) {
                    if eventUpdateTime == existingEvent.eventUpdatedDate {
                        //Found Updated Event
                        complete(existingEvent)
                    } else {
                        self.getEvent(eventID: eventID, completion: complete)
                    }
                } else {
                    self.getEvent(eventID: eventID, completion: complete)
                }
            }
        } else {
            complete(nil)
        }
    }
    
    func getEvent (eventID: String, completion: @escaping TREventObjCallBack) {
//        _ = TRGetEventRequest().getEventByID(eventID, completion: { (error, event) in
//            if let _ = event {
//                completion(event: event)
//            }
//        })
        completion(EventInfo())
    }
}
