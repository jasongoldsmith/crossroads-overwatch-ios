//
//  GroupInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class GroupInfo {
    
    var groupId         : String?
    var avatarPath      : String?
    var groupName       : String?
    var memberCount     : integer_t?
    var clanEnabled     : Bool?
    var eventCount      : integer_t?
    var groupNotification: Bool?
    
    func parseAndCreateObj (swiftyJson: JSON) {
        self.groupId = swiftyJson["groupId"].stringValue
        self.avatarPath = swiftyJson["avatarPath"].stringValue
        self.groupName = swiftyJson["groupName"].stringValue
        self.memberCount = swiftyJson["memberCount"].int32Value
        self.clanEnabled = swiftyJson["clanEnabled"].boolValue
        self.eventCount = swiftyJson["eventCount"].int32Value
        self.groupNotification = swiftyJson["muteNotification"].boolValue
    }
    
    func updateNotificationMuteValueForGroupWithID (groupID: String, notiValue: Bool) {
        let exsitingGroup = ApplicationManager.sharedInstance.groups.filter{$0.groupId == groupID}
        if let groupToUpdate = exsitingGroup.first {
            groupToUpdate.groupNotification = notiValue
        }
    }
}

