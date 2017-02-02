//
//  ForgotPasswordRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ForgotPasswordRequest: NSObject {
    
    func resetUserPassword(userName: String, consoleType: String, completion:@escaping TRValueCallBack) {
        let resetPassword = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_FORGOT_PASSWORD
        var params = [String: AnyObject]()
        params["consoleId"] = userName as AnyObject?
        params["consoleType"] = consoleType as AnyObject?
        let request = NetworkRequest.sharedInstance
        request.params = params
        request.requestURL = resetPassword
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(false)
                return
            }
            if let _ = swiftyJsonVar?["_id"].string {
                var existingEvent = ApplicationManager.sharedInstance.getEventById(eventId: (swiftyJsonVar?["_id"].string!)!)
                
                if let _ = existingEvent {
                    existingEvent = existingEvent?.parseCreateEventInfoObject(swiftyJason: swiftyJsonVar!)
                }
            }
            completion(true)
        }
    }
    
}
