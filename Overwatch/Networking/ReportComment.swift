//
//  ReportComment.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ReportComment: NSObject {
    
    func reportAComment (commentID: String, eventID: String, reportDetail: String?, reportedEmail: String?, completion:@escaping TRValueCallBack) {
        let reportURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_REPORT_COMMENT
        var params = [String: AnyObject]()
        params["eId"] = eventID as AnyObject?
        params["commentId"] = commentID as AnyObject?
        if let _ = reportDetail, let _ = reportedEmail {
            var issueDict = [String: AnyObject]()
            issueDict["reportDetails"] = reportDetail as AnyObject?
            issueDict["reporterEmail"] = reportedEmail as AnyObject?
            
            params["formDetails"] = issueDict as AnyObject?
        }
        let request = NetworkRequest.sharedInstance
        request.requestURL = reportURL
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
