//
//  OnBoardingCard.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 3/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON
import SDWebImage

class OnBoardingCard: NSObject {
    var required:Bool = true
    var language:String?
    var order:Int = 0
    var backgroundImage:UIImageView?
    var heroImage:UIImageView?
    var textImage:UIImageView?
    
    func parse(json:JSON) {
        if let backgroundURLString = json["backgroundImageUrl"].string,
            let backgroundURL = URL(string: backgroundURLString) {
            backgroundImage?.sd_setImage(with: backgroundURL)
        }
        if let imageURLString = json["heroImageUrl"].string,
            let imageUrl = URL(string: imageURLString) {
            heroImage?.sd_setImage(with: imageUrl)
        }
        if let logoURLString = json["textImageUrl"].string,
            let imageUrl = URL(string: logoURLString) {
            textImage?.sd_setImage(with: imageUrl)
        }
        if let isRequired = json["isRequired"].bool {
            required = isRequired
        }
        language = json["language"].string
        if let theOrder = json["order"].int {
            order = theOrder
        }
    }
    
}
