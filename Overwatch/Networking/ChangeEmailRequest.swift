//
//  ChangeEmailRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ChangeEmailRequest: NSObject {
    
    func updateUserEmail(password: String, newEmail: String, completion: @escaping TRResponseCallBack) {
        let updateUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CHANGE_EMAIL
        var params = [String: AnyObject]()

        params["password"] = password as AnyObject?
        params["newEmail"] = newEmail as AnyObject?
        
        let request = NetworkRequest.sharedInstance
        request.params = params
        request.requestURL = updateUserUrl
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let wrappedError = error {
                completion(wrappedError, nil)
                return
            }
            completion(nil, swiftyJsonVar)
            
        }
    }
}
