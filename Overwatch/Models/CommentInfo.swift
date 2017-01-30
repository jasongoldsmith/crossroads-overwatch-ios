//
//  CommentInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommentInfo: NSObject {
    
    var commentUserInfo: UserInfo?
    var commentText: String?
    var commentId: String?
    var commentCreated: String?
    var commentReported: Bool?
    
    
    func parseCommentInfo (commentInfo: JSON) {
        
        if let hasUserInfo = commentInfo["user"].dictionary {
            self.commentUserInfo = UserInfo()
            self.commentUserInfo!.parseUserResponseWithOutValueKey(responseObject: JSON(hasUserInfo))
        }
        
        self.commentText = commentInfo["text"].stringValue
        self.commentId = commentInfo["_id"].stringValue
        self.commentCreated = commentInfo["created"].stringValue
        self.commentReported = commentInfo["isReported"].boolValue
    }
}
