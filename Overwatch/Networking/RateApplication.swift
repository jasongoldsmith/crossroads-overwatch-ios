//
//  RateApplication.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class RateApplication: NSObject {
    
    func updateRateApplication(ratingStatus: String, completion:@escaping TRValueCallBack) {
        let requestURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_APP_REVIEW        
        var params = [String: AnyObject]()
        params["reviewPromptCardStatus"] = ratingStatus as AnyObject?
        let request = NetworkRequest.sharedInstance
        request.requestURL = requestURL
        request.params = params
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
