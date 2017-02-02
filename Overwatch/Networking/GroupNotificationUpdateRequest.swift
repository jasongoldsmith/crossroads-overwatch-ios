//
//  GroupNotificationUpdateRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class GroupNotificationUpdateRequest: NSObject {
    
    func updateUserGroupNotification (groupID: String, muteNoti: Bool, completion:@escaping TRValueCallBack) {
        let updateGroupNoti = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GROUP_NOTI_VALUE
        var params = [String: AnyObject]()
        params["groupId"] = groupID as AnyObject?
        params["muteNotification"] = muteNoti == true ? "true" as AnyObject? : "false" as AnyObject?

        let request = NetworkRequest.sharedInstance
        request.params = params
        request.requestURL = updateGroupNoti
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessage(errorString: "response error")
                completion(false)
                return
            }
            //Update the Noti Value for the group whose ID matches with the existing Bungie Group List
            if let hasGroupID = swiftyJsonVar?["groupId"].stringValue,
                let notiValue = swiftyJsonVar?["muteNotification"].boolValue {
                let bungieGroup = GroupInfo()
                bungieGroup.updateNotificationMuteValueForGroupWithID(groupID: hasGroupID, notiValue: notiValue)
            }
            completion(true)
        }
    }
    
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
