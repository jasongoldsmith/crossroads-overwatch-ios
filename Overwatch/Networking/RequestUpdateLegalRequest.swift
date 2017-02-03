//
//  RequestUpdateLegalRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/3/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class RequestUpdateLegalRequest: NSObject {
    
    func updateLegalAcceptance (completion:@escaping TRValueCallBack) {

        let addLegalUpdate = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LEGAL_ACCEPTED
        let request = NetworkRequest.sharedInstance
        request.requestURL = addLegalUpdate
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(false)
                return
            }
            let userData = UserInfo()
            userData.parseUserResponse(responseObject: swiftyJsonVar!)
            UserInfo.saveUserData(userData: userData)
            completion(true )
        }
    }
}
