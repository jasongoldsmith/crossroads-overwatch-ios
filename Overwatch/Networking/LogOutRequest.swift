//
//  LogOutRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class LogOutRequest: NSObject {
    //MARK:- LOGOUT USER
    func logoutUser(completion:@escaping (Bool?) -> ())  {
        
        if (UserInfo.isUserLoggedIn() == false) {
            completion(false )
        }
        
        let logoutUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LogoutUrl
        
        
        let request = NetworkRequest.sharedInstance
        request.requestURL = logoutUserUrl
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(false)
                return
            }
            //Remove saved user data
            UserInfo.removeUserData()
            
            completion(true )
        }
    }

}
