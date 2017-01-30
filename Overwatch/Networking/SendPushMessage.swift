//
//  SendPushMessage.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/25/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class SendPushMessage: NSObject {
    
    func sendEventMessage (eventId: String, messageString: String, completion: @escaping TRValueCallBack) {
        
        let pushMessageULR = K.TRUrls.TR_BaseUrl + "/api/v1/a/event/addComment"
        let request = NetworkRequest.sharedInstance
        request.requestURL = pushMessageULR
        var params = [String: AnyObject]()
        params["eId"] = eventId as AnyObject?
        params["text"] = messageString as AnyObject?
        request.params = params
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if error != nil {
                completion(nil)
                return
            }
            completion(true)
        }
    }
}

