//
//  CreateAReportRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class CreateAReportRequest: NSObject {
    
    func sendCreatedReport (reporterEmail: String, reportDetail: String, reportType: String, reporterID: String?, completion:@escaping TRValueCallBack) {
        let pushMessage = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_SEND_REPORT
        var params = [String: AnyObject]()
        params["reportDetails"] = reportDetail as AnyObject?
        params["reportType"] = reportType as AnyObject?
        params["reporterEmail"] = reporterEmail as AnyObject?
        if let _ = reporterID { params["reporter"] = reporterID as AnyObject? }
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
