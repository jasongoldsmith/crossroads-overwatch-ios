//
//  DeviceTokenRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/24/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class DeviceTokenRequest: NSObject {
    func sendDeviceToken(_ deviceToken: String, completion:@escaping TRValueCallBack) {
        let registerDeviceUrl = K.TRUrls.TR_BaseUrl + "/api/v1/a/installation/ios"
        let request = NetworkRequest.sharedInstance
        request.requestURL = registerDeviceUrl
        var params = [String: AnyObject]()
        params["deviceToken"] = deviceToken as AnyObject?
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
