//
//  CancelEventInvitationRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/25/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class CancelEventInvitationRequest: NSObject {
    
    func cancelInvitationRequest (eventID: String, playerID: String, completion: @escaping TRResponseCallBack) {
        let requestURL = K.TRUrls.TR_BaseUrl + "/api/v1/a/event/invite/cancel"
        let request = NetworkRequest.sharedInstance
        request.requestURL = requestURL
        var params = [String: AnyObject]()
        params["eId"] = eventID  as AnyObject?
        params["userId"] = playerID  as AnyObject?
        request.params = params
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let errorString = error {
                completion(errorString, nil)
                return
            }
            completion(nil, swiftyJsonVar)
        }
    }
}
