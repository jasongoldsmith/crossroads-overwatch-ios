//
//  PlayerInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation



class PlayerInfo: NSObject {
    
    var playerID            : String?
    var playerUserName      : String?
    var playerV             : String?
    var playerDate          : String?
    var playerPsnID         : String?
    var playerUdate         : String?
    var playerImageUrl      : String?
    var playerConsoles      : [Consoles] = []
    var playerConsoleId     : String?
    var playerClanTag       : String?
    var userVerified        : String?
    var commentsReported    : Int?
    var invitedBy           : String?
    var isPlayerActive      : Bool?
    var hasReachedMaxReportedComments: Bool?
    var verifyStatus    :String?
    var isInvited       :Bool?
    
    
    func getDefaultConsole () -> Consoles? {
        let currentConsole = self.playerConsoles.filter{$0.isPrimary == true}
        if let _ = currentConsole.first {
            return currentConsole.first!
        }
        
        return nil
    }
}

