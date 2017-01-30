//
//  LegalInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class LegalInfo: NSObject {
    
    var privacyVersion      : String?
    var termsVersion        : String?
    var termsNeedsUpdate    : Bool?
    var privacyNeedsUpdate  : Bool?
    
    func parseLegalObjectDictionary (responseObject: JSON) {
        
        self.privacyVersion = responseObject["privacyVersion"].stringValue
        self.termsVersion = responseObject["termsVersion"].stringValue
        self.termsNeedsUpdate = responseObject["termsNeedsUpdate"].boolValue
        self.privacyNeedsUpdate = responseObject["privacyNeedsUpdate"].boolValue
    }
}
