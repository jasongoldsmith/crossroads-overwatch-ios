//
//  ChangeConsoleRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ChangeConsoleRequest: NSObject {
    
    func changeConsole (consoleType: String, completion:@escaping TRValueCallBack) {
        let changeConsoleURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CHANGE_CONSOLE
        var params = [String: AnyObject]()
        params["consoleType"] = consoleType as AnyObject?
        let request = NetworkRequest.sharedInstance
        request.requestURL = changeConsoleURL
        request.params = params
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
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
            completion(true )
        }
    }
    
}
