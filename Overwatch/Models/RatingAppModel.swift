//
//  RatingAppModel.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/25/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class RatingAppModel: NSObject {
    
    var ratingInfoID: String?
    var ratingInfoName: String?
    var ratingInfoImageURL: String?
    var ratingCardText: String?
    var ratingInfoButtonText: String?
    
    func createRatingInfoObj (ratingInfo: JSON) {
        self.ratingInfoID = ratingInfo["_id"].stringValue
        self.ratingInfoName = ratingInfo["name"].stringValue
        self.ratingInfoImageURL = ratingInfo["imageUrl"].stringValue
        self.ratingCardText = ratingInfo["cardText"].stringValue
        self.ratingInfoButtonText = ratingInfo["buttonText"].stringValue
    }
}
