//
//  AddConsoleRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/26/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class AddConsoleRequest: NSObject {
    
    func addConsoleWith(consoleType: String, and consoleId:String, completion:@escaping TRResponseCallBack) {
        let addConsoleUrl = K.TRUrls.TR_BaseUrl + "/api/v1/a/user/addConsole"
        let request = NetworkRequest.sharedInstance
        request.requestURL = addConsoleUrl
        var params = [String: AnyObject]()
        params["consoleType"] = consoleType as AnyObject?
        params["consoleId"] = consoleId as AnyObject?
        request.params = params
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
