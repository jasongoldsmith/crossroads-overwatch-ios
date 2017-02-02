//
//  GroupsRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/19/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class GroupsRequest: NSObject {
    
    func getGroups (completion: @escaping TRValueCallBack) {
        let groupsURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GET_GROUPS
        let request = NetworkRequest.sharedInstance
        request.requestURL = groupsURL
        request.URLMethod = .get
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(false)
                return
            }
            
            //Remove all pre-saved groups
            ApplicationManager.sharedInstance.groups.removeAll()
            
            for group in (swiftyJsonVar?.arrayValue)! {
                let newGroup = GroupInfo()
                newGroup.parseAndCreateObj(swiftyJson: group)
                ApplicationManager.sharedInstance.groups.append(newGroup)
            }
            
            completion(true)
        }
    }
}
