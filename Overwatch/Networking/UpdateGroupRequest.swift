//
//  UpdateGroupRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class UpdateGroupRequest: NSObject {
    
    func updateUserGroup (groupID: String, groupName: String, groupImage: String, completion:@escaping TRValueCallBack) {
        let updateGroupUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_UPDATE_GROUPS
        var params = [String: AnyObject]()
        params["id"] = UserInfo.getUserID() as AnyObject?
        params["clanId"] = groupID as AnyObject?
        params["clanName"] = groupName as AnyObject?
        params["clanImageUrl"] = groupImage as AnyObject?
        
        
        let request = NetworkRequest.sharedInstance
        request.params = params
        request.requestURL = updateGroupUrl
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessage(errorString: "response error")
                completion(false)
                return
            }
            let userData = UserInfo()
            userData.parseUserResponse(responseObject: swiftyJsonVar!)
            
            for console in userData.consoles {
                if console.isPrimary == true {
                    UserInfo.saveConsolesObject(consoleObj: console)
                }
            }
            UserInfo.saveUserData(userData: userData)
            completion(true)
        }
    }
    
}
