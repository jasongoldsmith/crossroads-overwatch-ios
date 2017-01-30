//
//  CreateEventRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/19/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class CreateEventRequest: NSObject {
    
    func getTheListEvents (with aType:String, completion: @escaping TRValueCallBack) {
        let getListUrl = K.TRUrls.TR_BaseUrl + "/api/v1/activity/list"
        let request = NetworkRequest.sharedInstance
        request.requestURL = getListUrl
        var params = [String: AnyObject]()
        params["aType"] = aType as AnyObject?
        params["includeTags"] = true as AnyObject?
        request.params = params
        request.URLMethod = .get
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(false)
                return
            }
            
            // Remove all pre-fetched and saved activities
            ApplicationManager.sharedInstance.activityList.removeAll()
            
            guard let activityArray = swiftyJsonVar?.arrayValue else {
                completion(false)
                return
            }
            if activityArray.count == 0 {
                completion(false)
                return
            }
            for activity in activityArray {
                let activityInfo = ActivityInfo().parseAndCreateActivityObject(swiftyJson: activity)
                ApplicationManager.sharedInstance.activityList.append(activityInfo)
            }

            completion(true)
        }
    }

    func createAnEventWithActivity (activity: ActivityInfo, selectedTime: NSDate?, completion: @escaping TREventObjCallBack) {
        
        let createEventUrl = K.TRUrls.TR_BaseUrl + "/api/v1/a/event/create"
        
        // Current Player
        let player = UserInfo.getUserID() as AnyObject?
        
        //Add Parameters
        var params = [String: AnyObject]()
        params["eType"] = activity.activityID! as AnyObject?
        params["minPlayers"] = activity.activityMinPlayers!
        params["maxPlayers"] = activity.activityMaxPlayers!
        params["creator"] = UserInfo.getUserID() as AnyObject?
        params["players"] = player
        
        if let hasSelectedTime = selectedTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            
            formatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!;
            let utcTimeZoneStr = formatter.string(from: hasSelectedTime as Date);
            
            params["launchDate"] = utcTimeZoneStr as AnyObject?
        }
        
//        let params:[String: AnyObject] = ["eType" : aType as AnyObject, "minPlayers" : 1 as AnyObject, "maxPlayers" : 5 as AnyObject]
        // Create Request
        let request = NetworkRequest.sharedInstance
        request.requestURL = createEventUrl
        request.params = params
        request.URLMethod = .post
        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
//                ApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(nil)
                
                return
            }
            
            // Creating Event Objects from Events List
            let eventInfo = EventInfo().parseCreateEventInfoObject(swiftyJason: swiftyJsonVar!)
            if let hasEventID = eventInfo.eventID {
                if let eventToUpdate = ApplicationManager.sharedInstance.getEventById(eventId: hasEventID) {
                    let eventIndex = ApplicationManager.sharedInstance.eventsList.index(of: eventToUpdate)
                    ApplicationManager.sharedInstance.eventsList.remove(at: eventIndex!)
                }
            }
            
            
            ApplicationManager.sharedInstance.eventsList.insert(eventInfo, at: 0)
            
            
            completion(eventInfo)
        }
    }
}
