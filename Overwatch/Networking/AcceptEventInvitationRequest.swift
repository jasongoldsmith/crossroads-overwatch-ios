//
//  AcceptEventInvitationRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/25/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class AcceptEventInvitationRequest: NSObject {
    
    func acceptInvitationRequest (eventID: String, completion: @escaping TREventObjCallBackWithError) {
        let requestURL = K.TRUrls.TR_BaseUrl + "/api/v1/a/event/invite/accept"
        let request = NetworkRequest.sharedInstance
        request.requestURL = requestURL
        var params = [String: AnyObject]()
        params["eId"] = eventID  as AnyObject?
        request.params = params
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let errorString = error {
                completion(errorString, nil)
                return
            }
            let eventObj = EventInfo().parseCreateEventInfoObject(swiftyJason: swiftyJsonVar!)
            completion(nil, eventObj)
        }
    }

}
