//
//  GetEventRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/25/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class GetEventRequest: NSObject {
    func getEvent(_ eventID: String, completion:@escaping TREventObjCallBackWithError) {
        let eventInfoULR = K.TRUrls.TR_BaseUrl + "/api/v1/a/event/listById"
        let request = NetworkRequest.sharedInstance
        request.requestURL = eventInfoULR
        var params = [String: AnyObject]()
        params["id"] = eventID as AnyObject?
        request.params = params
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let errorString = error {
                completion(errorString, nil)
                return
            }
            if let jsonVar = swiftyJsonVar {
                let eventObj = EventInfo().parseCreateEventInfoObject(swiftyJason: jsonVar)
                completion(nil, eventObj)
            }
        }
    }
}
