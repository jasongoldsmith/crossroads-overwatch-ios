//
//  AppTrackingRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class AppTrackingRequest: NSObject {
    
    func sendApplicationPushNotiTracking (notiDict: NSDictionary?, trackingType: APP_TRACKING_DATA_TYPE, completion:@escaping TRValueCallBack) {
        let appTrackingUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_APP_TRACKING
        var params = [String: AnyObject]()
        
        if let _ = notiDict {
            params["trackingData"] = notiDict as AnyObject?
        } else {
            params["trackingData"] = NSDictionary() as AnyObject?
        }
        
        params["trackingKey"] = trackingType.rawValue as AnyObject?

        let request = NetworkRequest.sharedInstance
        request.params = params
        request.requestURL = appTrackingUrl
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(false)
                return
            }
            completion(true)
        }
    }
        
}
