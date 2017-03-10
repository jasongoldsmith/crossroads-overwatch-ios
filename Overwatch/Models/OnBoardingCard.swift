//
//  OnBoardingCard.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 3/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class OnBoardingCard: NSObject {
    var imageURL:String?
    var backgroundURL: String?
    var logoAndTextURL:String?
    var required:Bool = true
    var language:String?
    var order:Int = 0
    
    func parse(json:JSON) {
        backgroundURL = json["backgroundImageUrl"].string
        imageURL = json["heroImageUrl"].string
        logoAndTextURL = json["textImageUrl"].string
        if let isRequired = json["isRequired"].bool {
            required = isRequired
        }
        language = json["language"].string
        if let theOrder = json["order"].int {
            order = theOrder
        }
    }
    
}
