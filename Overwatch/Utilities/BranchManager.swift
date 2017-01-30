//
//  BranchManager.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/20/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import Branch
import SwiftyJSON

//typealias ErrorTypeCallBack = (errorType: Branch_Error?) -> ()

class BranchManager {
    
    let canonicalIdentifier = "canonicalIdentifier"
    var branchUniversalObject = BranchUniversalObject()
    let canonicalUrl = "https://dev.branch.io/getting-started/deep-link-routing/guide/ios/"
    let contentTitle = "contentTitle"
    let contentDescription = "My Content Description"
    let imageUrl = "https://pbs.twimg.com/profile_images/658759610220703744/IO1HUADP.png"
    let feature = "Sharing Feature"
    let channel = "Distribution Channel"
    let desktop_url = "http://branch.io"
    let ios_url = "http://crossrd.app.link/eQIMLli1Yu"
    let shareText = "Super amazing thing I want to share"
    let user_id1 = "abe@emailaddress.io"
    let user_id2 = "ben@emailaddress.io"
    let live_key = "key_live_ilh33QPvqAgDqnVVRh8iXcnnBBaLIp97"
    let test_key = "key_test_eipYWJLAEvhEqkSRNoZp2lmlvqmOIrkl"
    
    func createLinkWithBranch (eventInfo: EventInfo, deepLinkType: String, callback: @escaping callbackWithUrl) {
        
        var extraPlayersRequiredCount: Int = 0
        guard let eventID = eventInfo.eventID else {
            return
        }
        
        guard let maxPlayers = eventInfo.eventActivity?.activityMaxPlayers?.intValue else {
            return
        }
        
        extraPlayersRequiredCount = maxPlayers - eventInfo.eventPlayersArray.count
        var playerCount: String = ""
        if extraPlayersRequiredCount > 0 {
            playerCount = String(extraPlayersRequiredCount)
        }
        let console = self.getConsoleTypeFromString(consoleName: eventInfo.eventConsoleType!)
        var activityName = ""
        
        //Formatted Date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let eventDate = formatter.date(from: eventInfo.eventLaunchDate!)
        let nextFormatter = DateFormatter()
        nextFormatter.dateFormat = "MMM d 'at' h:mm a"
        let formatedDate = nextFormatter.string(from: eventDate!)
        
        // Group Name
        var groupName = ""
        if let currentGroupID = UserInfo.getUserClanID() {
            if let hasCurrentGroup = ApplicationManager.sharedInstance.getCurrentGroup(groupID: currentGroupID) {
                groupName = hasCurrentGroup.groupName!
            }
        }
        
        if let aName = eventInfo.eventActivity?.activitySubType! {
            activityName = aName
        }
        
        // Create Branch Object
        branchUniversalObject = BranchUniversalObject.init(canonicalIdentifier: canonicalIdentifier)
        var messageString = "\(console): I need \(playerCount) more for \(activityName) in the \(groupName) group"
        
        if
            ApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event: eventInfo) {
            branchUniversalObject.title = "Join My Fireteam"
            if eventInfo.eventPlayersArray.count == eventInfo.eventMaxPlayers!.intValue {
                branchUniversalObject.title = eventInfo.eventActivity?.activitySubType
            }
            
            messageString = "\(console): I need \(playerCount) more for \(activityName) in the \(groupName) group"
        } else {
            branchUniversalObject.title = "Searching for Guardians"
            if eventInfo.eventPlayersArray.count == eventInfo.eventMaxPlayers!.intValue {
                branchUniversalObject.title = eventInfo.eventActivity?.activitySubType
            }
            
            messageString = "\(console): This fireteam needs \(extraPlayersRequiredCount) more for \(activityName) in the \(groupName) group"
            
            if eventInfo.isFutureEvent == true {
                messageString = "\(console): This fireteam needs \(playerCount) more for \(activityName) on \(formatedDate) in the \(groupName) group"
            }
        }
        
        if extraPlayersRequiredCount == 0 {
            branchUniversalObject.title = eventInfo.eventActivity?.activitySubType
            if eventInfo.isFutureEvent == true {
                messageString = "\(console): Check out this \(activityName) on \(formatedDate) in the \(groupName) group"
            } else {
                messageString = "\(console): Check out this \(activityName) in the \(groupName) group"
            }
        }
        
        branchUniversalObject.contentDescription = messageString
        
        if let hasActivityCard = eventInfo.eventActivity?.activityID {
            let imageString = "http://w3.crossroadsapp.co/bungie/share/branch/v1/\(hasActivityCard)"
            branchUniversalObject.imageUrl  = imageString
        } else {
            branchUniversalObject.imageUrl  = "http://w3.crossroadsapp.co/bungie/share/branch/v1/default.png"
        }
        
        branchUniversalObject.addMetadataKey("eventId", value: eventID)
        branchUniversalObject.addMetadataKey("deepLinkType", value: deepLinkType)
        branchUniversalObject.addMetadataKey("activityName", value: (eventInfo.eventActivity?.activitySubType)!)
        
        // Create Link
        let linkProperties = BranchLinkProperties()
        branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
            if (error == nil) {
                callback(url, nil)
                
            } else {
                print("Branch TestBed: \(error)")
            }
        }
    }
    
    
    func createInvitationLinkWithBranch (eventInfo: EventInfo, playerArray: [String], deepLinkType: String, callback: @escaping callbackWithUrl) {
        
        guard let eventID = eventInfo.eventID else {
            return
        }
        
        let arrayString = playerArray.joined(separator: ",")
        branchUniversalObject = BranchUniversalObject.init(canonicalIdentifier: canonicalIdentifier)
        branchUniversalObject.addMetadataKey("eventId", value: eventID)
        branchUniversalObject.addMetadataKey("deepLinkType", value: deepLinkType)
        branchUniversalObject.addMetadataKey("invitees", value: arrayString)
        branchUniversalObject.addMetadataKey("activityName", value: (eventInfo.eventActivity?.activitySubType)!)
        
        
        // Create Link
        let linkProperties = BranchLinkProperties()
        branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
            if (error == nil) {
                callback(url, nil)
                
            } else {
                print("Branch TestBed: \(error)")
            }
        }
    }
    
    
    func getConsoleTypeFromString (consoleName: String) -> String {
        
        var consoleType = ""
        switch consoleName {
        case "PS4":
            consoleType = "PS4"
            break
        case "PS3":
            consoleType = "PS3"
            break
        case "XBOX360":
            consoleType = "360"
            break
        default:
            consoleType = "XB1"
            break
        }
        
        return consoleType
    }
}

