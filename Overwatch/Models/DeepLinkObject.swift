//
//  DeepLinkObject.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/14/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON


class DeepLinkObject: NSObject {
    
    var deepLinkString: String?
    var deepLinkKey: String?
    
    init(link: String) {
        
        super.init()
        
        let finalString = link.replacingOccurrences(of: "forcecatalystcrossroadsoverwatch://", with: "")
        let trimmedString = finalString.trimmingCharacters(in: .whitespaces)
        let parsedKeys = trimmedString.components(separatedBy: ["/"])
        
        if let _ = parsedKeys.first {
            self.deepLinkKey = parsedKeys.first
            self.deepLinkString = trimmedString.replacingOccurrences(of: self.deepLinkKey!, with: "")
        }
    }
    
    
    func createLinkInfoAndPassToBackEnd () -> Dictionary <String, String>? {
        
        if let _ = self.deepLinkKey {
            let paramDict: [String: String] = [self.deepLinkKey! : self.deepLinkString!]
            return paramDict
        }
        
        return nil
    }
}
