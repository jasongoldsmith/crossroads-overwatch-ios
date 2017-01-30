//
//  ActivityInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActivityInfo: NSObject {
    
    var activityID            : String?
    var activitySubType       : String?
    var activityLight         : NSNumber?
    var activityV             : String?
    var activityCheckPoint    : String?
    var activityType          : String?
    var activityDificulty     : String?
    var activityMaxPlayers    : NSNumber?
    var activityMinPlayers    : NSNumber?
    var activityIconImage     : String?
    var activityIsFeatured    : Bool?
    var activitylocation      : LocationInfo?
    var activityLevel         : String?
    var activityAdCard        : AdCardInfo?
    var activityDescription   : String?
    var activityCheckPointOrder: NSNumber?
    var activityStory: String?
    var activityCardOrder: String?
    var activityTag: String?
    var activityImageBasePath: String?
    var activityImage: String?
    var activityIsActive: Bool?
    var activityBonus: [ActivityBonus] = []
    var activityModifiers: [ActivityModifiersInfo] = []
    
    
    func parseAndCreateActivityObject (swiftyJson: JSON) -> ActivityInfo {
        
        self.activityID         = swiftyJson["_id"].stringValue
        self.activitySubType    = swiftyJson["aSubType"].stringValue
        self.activityCheckPoint = swiftyJson["aCheckpoint"].stringValue
        self.activityType       = swiftyJson["aType"].stringValue
        self.activityDificulty  = swiftyJson["aDifficulty"].stringValue
        self.activityLight      = swiftyJson["aLight"].numberValue
        self.activityMaxPlayers = swiftyJson["maxPlayers"].numberValue
        self.activityMinPlayers = swiftyJson["minPlayers"].numberValue
        self.activityIconImage  = swiftyJson["aIconUrl"].stringValue
        self.activityIsFeatured = swiftyJson["isFeatured"].boolValue
        self.activityLevel      = swiftyJson["aLevel"].stringValue
        self.activityCheckPointOrder = swiftyJson["aCheckpointOrder"].numberValue
        self.activityStory = swiftyJson["aStory"].stringValue
        self.activityCardOrder = swiftyJson["aCardOrder"].stringValue
        self.activityTag = swiftyJson["tag"].stringValue
        self.activityImageBasePath = swiftyJson["aImage"][["aImageBaseUrl"]].stringValue
        self.activityImage = self.activityImageBasePath! + swiftyJson["aImage"][["aImageImagePath"]].stringValue
        self.activityIsActive = swiftyJson["isActive"].boolValue
        self.activityDescription = swiftyJson["aDescription"].stringValue
        
        
        if let aLocation = swiftyJson["aLocation"].dictionary {
            let location = LocationInfo()
            location.parseLocationDict(locationDict: JSON(aLocation))
            
            self.activitylocation = location
        }
        
        
        if let card = swiftyJson["adCard"].dictionary {
            let acitivityCard = AdCardInfo()
            self.activityAdCard = acitivityCard.parseAndCreateActivityObject(swiftyJson: JSON(card))
        }
        
        let bonus = swiftyJson["aBonus"].arrayValue
        for bonusInfo in bonus {
            let activityBonus = ActivityBonus()
            activityBonus.parseActivityBonus(activityBonus: bonusInfo)
            
            self.activityBonus.append(activityBonus)
        }
        
        
        let modifiers = swiftyJson["aModifiers"].arrayValue
        for modifiersInfo in modifiers {
            let activityModifier = ActivityModifiersInfo()
            activityModifier.parseActivityModifiers(activityModifiers: modifiersInfo)
            
            self.activityModifiers.append(activityModifier)
        }
        
        
        return self
    }
}
