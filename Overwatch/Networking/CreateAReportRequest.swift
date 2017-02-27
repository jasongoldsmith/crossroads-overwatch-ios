//
//  CreateAReportRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class CreateAReportRequest: NSObject {
    
    func sendCreatedReport (description: String, sourceCode: Int, errorCode: Int?, completion:@escaping TRValueCallBack) {
        let pushMessage = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_SEND_REPORT
        var params = [String: AnyObject]()
        params["description"] = description as AnyObject?
        params["sourceCode"] = sourceCode as AnyObject?
        if let theErrorCode = errorCode {
            params["errorCode"] = theErrorCode as AnyObject?
        }
        let request = NetworkRequest.sharedInstance
        request.requestURL = pushMessage
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

    func sendCreatedReportForNotLoggedUser (email:String, description: String, sourceCode: Int, errorCode: Int?, completion:@escaping TRValueCallBack) {
        let pushMessage = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_SEND_REPORT_UNAUTH
        var params = [String: AnyObject]()
        params["email"] = email as AnyObject?
        params["description"] = description as AnyObject?
        params["sourceCode"] = sourceCode as AnyObject?
        if let theErrorCode = errorCode {
            params["errorCode"] = theErrorCode as AnyObject?
        }
        let request = NetworkRequest.sharedInstance
        request.requestURL = pushMessage
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
