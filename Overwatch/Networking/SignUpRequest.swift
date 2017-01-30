//
//  SignUpRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/26/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class SignUpRequest: NSObject {
    
    func signUpWith(email: String, and password:String, completion:@escaping TRValueCallBack) {
        let signUpUrl = K.TRUrls.TR_BaseUrl + "/api/v1/auth/signUp"
        let request = NetworkRequest.sharedInstance
        request.requestURL = signUpUrl
        var params = [String: AnyObject]()
        params["email"] = email as AnyObject?
        params["password"] = password as AnyObject?
        request.params = params
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(nil)
                return
            }
            completion(true)
        }
    }
}
