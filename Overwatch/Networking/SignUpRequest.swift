//
//  SignUpRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/26/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class SignUpRequest: NSObject {
    
    func signUpWith(email: String, and password:String, completion:@escaping TRResponseCallBack) {
        let signUpUrl = K.TRUrls.TR_BaseUrl + "/api/v1/auth/signUp"
        var params = [String: AnyObject]()
        params["email"] = email as AnyObject?
        params["password"] = password as AnyObject?
        let request = NetworkRequest.sharedInstance
        request.requestURL = signUpUrl
        request.params = params
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let wrappedError = error {
                completion(wrappedError, nil)
                return
            }
            let userData = UserInfo()
            userData.parseUserResponse(responseObject: swiftyJsonVar!)
            UserInfo.saveUserData(userData: userData)
            completion(nil, swiftyJsonVar)
        }
    }
}
