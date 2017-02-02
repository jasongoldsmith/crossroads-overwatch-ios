//
//  KickInActiveUserRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class KickInActiveUserRequest: NSObject {
    
    func kickInActiveUser (eventID: String, playerID: String, completion:@escaping TRResponseCallBack) {
        let requestURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_KICK_PLAYER
        var params = [String: AnyObject]()
        params["eId"] = eventID  as AnyObject?
        params["userId"] = playerID  as AnyObject?
        
        let request = NetworkRequest.sharedInstance
        request.requestURL = requestURL
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
