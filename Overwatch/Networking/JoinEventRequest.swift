//
//  JoinEventRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/23/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class JoinEventRequest: NSObject {
    func joinEventWithUserForEvent(_ userId: String, eventInfo:EventInfo, completion:@escaping TREventObjCallBack) {
        let joinEventUrl = K.TRUrls.TR_BaseUrl + "/api/v1/a/event/join"
        let request = NetworkRequest.sharedInstance
        request.requestURL = joinEventUrl
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
            
            if let _ = existingEvent {
                existingEvent = existingEvent?.parseCreateEventInfoObject(swiftyJason: swiftyJsonVar!)
            }
            
            completion(existingEvent)
        }
    }
}
