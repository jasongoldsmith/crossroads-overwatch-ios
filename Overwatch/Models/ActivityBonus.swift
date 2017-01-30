//
//  ActivityBonus.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActivityBonus: NSObject {
    
    var aId: String?
    var aBonusName: String?
    var aBonusInfo: String?
    var aIsActive: String?
    
    func parseActivityBonus (activityBonus: JSON) {
        
        self.aId = activityBonus["_id"].stringValue
        self.aIsActive = activityBonus["isActive"].stringValue
        self.aBonusName = activityBonus["aBonusName"].stringValue
        self.aBonusInfo = activityBonus["aBonusInfo"].stringValue
    }
}
