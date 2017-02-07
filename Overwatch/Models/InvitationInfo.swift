//
//  InvitationInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/6/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class InvitationInfo: NSObject {
    var eventID: String?
    var invitedPlayers: String?
    
    func createSignInInvitationPayLoad () -> NSDictionary {
        
        var invi = [String: AnyObject]()
        let playersArray : [String] = invitedPlayers!.components(separatedBy: [","])
        
        invi["eId"] = self.eventID as AnyObject?
        invi["invitees"] = playersArray as AnyObject?
        
        return invi as NSDictionary
    }
}
