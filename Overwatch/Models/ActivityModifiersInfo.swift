//
//  ActivityModifiersInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActivityModifiersInfo: NSObject {
    
    var aId: String?
    var aModifierName: String?
    var aModifierInfo: String?
    var aIsActive: String?
    
    func parseActivityModifiers (activityModifiers: JSON) {
        
        self.aId = activityModifiers["_id"].stringValue
        self.aModifierName = activityModifiers["aModifierName"].stringValue
        self.aModifierInfo = activityModifiers["aModifierInfo"].stringValue
        self.aIsActive = activityModifiers["isActive"].stringValue
    }
}
