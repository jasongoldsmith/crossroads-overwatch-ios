//
//  ProfileRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/19/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ProfileRequest: NSObject {
    
    func getProfile (completion: @escaping TRValueCallBack) {
        let profileURL = K.TRUrls.TR_BaseUrl + "/api/v1/a/user/self"
        let request = NetworkRequest.sharedInstance
        request.requestURL = profileURL
        request.URLMethod = .get
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(false)
                return
            }
            
            let userData = UserInfo()
            userData.parseUserResponse(responseObject: swiftyJsonVar!)
            
            UserInfo.saveUserData(userData: userData)
            
            completion(true)
        }
    }
}
