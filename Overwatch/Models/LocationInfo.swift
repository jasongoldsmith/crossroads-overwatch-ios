//
//  LocationInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON


class LocationInfo: NSObject {
    
    var aSubLocation: String?
    var aDirectorLocation: String?
    
    func parseLocationDict (locationDict: JSON) {
        self.aSubLocation = locationDict["aSubLocation"].stringValue
        self.aDirectorLocation = locationDict["aDirectorLocation"].stringValue
    }
}
