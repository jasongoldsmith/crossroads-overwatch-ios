//
//  ForgotPasswordRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ForgotPasswordRequest: NSObject {
    
    func resetUserPassword(userEmail: String, completion:@escaping TRResponseCallBack) {
        let resetPassword = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_FORGOT_PASSWORD
        var params = [String: AnyObject]()
        params["email"] = userEmail as AnyObject?
        let request = NetworkRequest.sharedInstance
        request.params = params
        request.requestURL = resetPassword
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
