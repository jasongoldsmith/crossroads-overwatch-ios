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
import Fabric

//typealias ErrorTypeCallBack = (errorType: Branch_Error?) -> ()

class BranchManager {
    
    let canonicalIdentifier = "Crossroads for Overwatch"
    var branchUniversalObject = BranchUniversalObject()
    let canonicalUrl = "https://dev.branch.io/getting-started/deep-link-routing/guide/ios/"
    let contentTitle = "contentTitle"
    let contentDescription = "My Content Description"
    let imageUrl = "https://pbs.twimg.com/profile_images/658759610220703744/IO1HUADP.png"
    let feature = "Sharing Feature"
    let channel = "Distribution Channel"
    let desktop_url = "http://branch.io"
    let ios_url = "https://crsrdsoverwatch.app.link/WJGmVZrzyA"
    let shareText = "Super amazing thing I want to share"
    let user_id1 = "abe@emailaddress.io"
    let user_id2 = "ben@emailaddress.io"
    let live_key = "key_live_lnAe1OYP1wS0wIoMHoExTmhaFApqc1Nc"
    let test_key = "key_test_ajwkZHZI8uV7zGaKGmEUCbmbyDbCi2Qv"
    
    func createLinkWithBranch (eventInfo: EventInfo, deepLinkType: String, callback: @escaping callbackWithUrl) {
        
        var extraPlayersRequiredCount: Int = 0
        guard let eventID = eventInfo.eventID,
            let maxPlayers = eventInfo.eventActivity?.activityMaxPlayers?.intValue,
            let consoleType = eventInfo.eventConsoleType,
            let console = ApplicationManager.sharedInstance.getConsoleNameFrom(consoleType: consoleType) else {
            return
        }
        
        extraPlayersRequiredCount = maxPlayers - eventInfo.eventPlayersArray.count
        var playerCount: String = ""
        if extraPlayersRequiredCount > 0 {
            playerCount = String(extraPlayersRequiredCount)
        }
        
        
        var activityName = ""
        
        //Formatted Date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        var formatedDate = ""
        if let launchDate = eventInfo.eventLaunchDate,
            let eventDate = formatter.date(from: launchDate) {
            let nextFormatter = DateFormatter()
            nextFormatter.dateFormat = "MMM d 'at' h:mm a"
            formatedDate = nextFormatter.string(from: eventDate)
        }
        
        // Group Name
        var groupName = ""
        if let currentGroupID = UserInfo.getUserClanID(),
            let theGroupName = ApplicationManager.sharedInstance.getCurrentGroup(groupID: currentGroupID)?.groupName {
                groupName = theGroupName
        }
        
        if let aName = eventInfo.eventActivity?.activitySubType {
            activityName = aName
        }
        
        // Create Branch Object
        branchUniversalObject = BranchUniversalObject.init(canonicalIdentifier: canonicalIdentifier)
        var messageString = "\(console): I need \(playerCount) more for \(activityName) in the \(groupName) region"
        
        if
            ApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event: eventInfo) {
            branchUniversalObject.title = "Join My Team"
            if eventInfo.eventPlayersArray.count == eventInfo.eventMaxPlayers!.intValue {
                branchUniversalObject.title = eventInfo.eventActivity?.activitySubType
            }
            
            messageString = "\(console): I need \(playerCount) more for \(activityName) in the \(groupName) region"
        } else {
            branchUniversalObject.title = "Searching for Heroes"
            if eventInfo.eventPlayersArray.count == eventInfo.eventMaxPlayers!.intValue {
                branchUniversalObject.title = eventInfo.eventActivity?.activitySubType
            }
            
            messageString = "\(console): This team needs \(extraPlayersRequiredCount) more for \(activityName) in the \(groupName) region"
            
            if eventInfo.isFutureEvent == true {
                messageString = "\(console): This team needs \(playerCount) more for \(activityName) on \(formatedDate) in the \(groupName) region"
            }
        }
        
        if extraPlayersRequiredCount == 0 {
            branchUniversalObject.title = eventInfo.eventActivity?.activitySubType
            if eventInfo.isFutureEvent == true {
                messageString = "\(console): Check out this \(activityName) on \(formatedDate) in the \(groupName) region"
            } else {
                messageString = "\(console): Check out this \(activityName) in the \(groupName) region"
            }
        }
        
        branchUniversalObject.contentDescription = messageString
        
        branchUniversalObject.imageUrl  = "https://s3-us-west-1.amazonaws.com/w3.crossroadsapp.co/overwatch/ow_branch.png"
        
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

