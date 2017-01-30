//
//  LeaveEventRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/23/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class LeaveEventRequest: NSObject {
    func leaveAnEvent(_ eventInfo:EventInfo, completion:@escaping TREventObjCallBack) {
        let leaveEventtUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LeaveEventUrl
        let request = NetworkRequest.sharedInstance
        request.requestURL = leaveEventtUrl
        var params = [String: AnyObject]()
        params["eId"] = eventInfo.eventID as AnyObject?
        params["player"] = UserInfo.getUserID() as AnyObject?
        request.params = params
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(nil)
                return
            }
            
            guard let _ = swiftyJsonVar?["_id"].string else {
                completion(nil)
                return
            }
            
            // Creating Event Objects from Events List
            var existingEvent = ApplicationManager.sharedInstance.getEventById(eventId: (swiftyJsonVar?["_id"].string!)!)
            
            
            // If there's no creator info in the JSON feed then it means you were the last person in the event and since you left
            // the whole event has been deleted.
            let creatorDict = swiftyJsonVar?["creator"].dictionary
            if (creatorDict == nil) {
                if existingEvent != nil {
                    ApplicationManager.sharedInstance.eventsList.remove(at: ApplicationManager.sharedInstance.eventsList.index(of: existingEvent!)!)
                }
                completion(existingEvent)
                
                return
            }
            
            if let _ = existingEvent {
                existingEvent = existingEvent?.parseCreateEventInfoObject(swiftyJason: swiftyJsonVar!)
            }
            
            completion(existingEvent)
        }
    }
}
