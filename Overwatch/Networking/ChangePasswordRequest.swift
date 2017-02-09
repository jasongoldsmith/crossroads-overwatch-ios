//
//  ChangePasswordRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ChangePasswordRequest: NSObject {
    func updateUserPassword(newPassword: String, oldPassword: String, completion: @escaping TRResponseCallBack) {
        
        let updateUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CHANGE_PASSWORD
        var params = [String: AnyObject]()
        params["newPassword"] = newPassword as AnyObject?
        params["oldPassword"] = oldPassword as AnyObject?
        
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
