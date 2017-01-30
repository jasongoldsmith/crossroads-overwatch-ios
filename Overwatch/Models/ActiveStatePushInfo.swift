//
//  ActiveStatePushInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ActiveStatePushInfo {
    
    var alertString: String?
    var eventName: String?
    var apsData: NSDictionary?
    var isMessageNotification: Bool?
    var pushId: String?
    var updateTime: String?
    var eventID: String?
    var imageURL: String?
    var halmetImage: String?
    var eventconsole: String?
    var eventClanName: String?
    var playerMessageConsoleName: String?
    
    
    func parsePushNotificationPayLoad (sender: NSNotification) {
        if let userInfo = sender.userInfo as NSDictionary? {
            if let payload = userInfo.object(forKey: "payload") as? NSDictionary {
                
                
                if let notificationType = payload.object(forKey: "notificationName") as? String, notificationType == NOTIFICATION_NAME.NOTI_MESSAGE_PLAYER.rawValue {
                    self.isMessageNotification = true
                } else {
                    self.isMessageNotification = false
                }
                
                if let updateTime = payload.object(forKey: "eventUpdated") as? String {
                    self.updateTime = updateTime
                }
                
                if let eventName = payload.object(forKey: "eventName") as? String {
                    self.eventName = eventName
                }
                
                if let eventID = payload.object(forKey: "eventId") as? String {
                    self.eventID = eventID
                }
                
                if let eventImage = payload.object(forKey: "clanImageUrl") as? String {
                    self.imageURL = eventImage
                }
                
                if let eventImage = payload.object(forKey: "eventClanImageUrl") as? String {
                    self.imageURL = eventImage
                }
                
                if let evtConsole = payload.object(forKey: "eventConsole") as? String {
                    self.eventconsole = evtConsole
                }
                
                if let evtClanName = payload.object(forKey: "eventClanName") as? String {
                    self.eventClanName = evtClanName
                }
                
                if let playerImage = payload.object(forKey: "messengerImageUrl") as? String {
                    self.halmetImage = playerImage
                }
                
                if let playerName = payload.object(forKey: "messengerConsoleId") as? String {
                    self.playerMessageConsoleName = playerName
                }
                
                if let apsData = userInfo.object(forKey: "aps") as? NSDictionary {
                    
                    self.apsData = apsData
                    
                    if let alertString = self.apsData?.object(forKey: "alert") as? String {
                        self.alertString = alertString
                    }
                }
            }
        }
    }
}

