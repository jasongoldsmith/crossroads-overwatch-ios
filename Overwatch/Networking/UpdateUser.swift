//
//  TRUpdateUser.swift
//  Traveler
//
//  Created by Ashutosh on 4/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class UpdateUser: NSObject {
    
    func updateUserPassword(newPassword: String?, oldPassword: String?, completion: @escaping TRValueCallBack) {
        
        let updateUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CHANGE_PASSWORD
        var params = [String: AnyObject]()
        params["id"] = UserInfo.getUserID() as AnyObject?
        
        if let _ = newPassword {
            params["newPassWord"] = newPassword as AnyObject?
        }
        if let _ = oldPassword {
            params["oldPassWord"] = oldPassword as AnyObject?
        }
        
        let request = NetworkRequest.sharedInstance
        request.params = params
        request.requestURL = updateUserUrl
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(false)
                
                return
            }
            
            completion(true )
        }
    }
    
    func updateUserEmail(newEmail: String?, oldEmail: String?, completion: @escaping TRValueCallBack) {
        
        
        let updateUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CHANGE_EMAIL
        var params = [String: AnyObject]()
        params["id"] = UserInfo.getUserID() as AnyObject?
        
        if let _ = newEmail {
            params["newEmail"] = newEmail as AnyObject?
        }
        if let _ = oldEmail {
            params["oldEmail"] = oldEmail as AnyObject?
        }
        
        let request = NetworkRequest.sharedInstance
        request.params = params
        request.requestURL = updateUserUrl
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(false)
                
                return
            }
            
            completion(true )
        }
    }
}
