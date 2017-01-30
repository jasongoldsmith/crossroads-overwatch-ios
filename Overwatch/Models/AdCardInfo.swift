//
//  AdCardInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class AdCardInfo: NSObject {
    
    var adCardBaseUrl      : String?
    var adCardImageURL     : String?
    var adCardCardHeader   : String?
    var adCardSubHeader    : String?
    var adCardIsAdCard     : Bool?
    
    func parseAndCreateActivityObject (swiftyJson: JSON) -> AdCardInfo {
        
        self.adCardBaseUrl      = swiftyJson["adCardBaseUrl"].stringValue
        self.adCardImageURL     = swiftyJson["adCardImagePath"].stringValue
        self.adCardCardHeader   = swiftyJson["adCardHeader"].stringValue
        self.adCardSubHeader    = swiftyJson["adCardSubHeader"].stringValue
        self.adCardIsAdCard     = swiftyJson["isAdCard"].boolValue
        
        return self
    }
}
