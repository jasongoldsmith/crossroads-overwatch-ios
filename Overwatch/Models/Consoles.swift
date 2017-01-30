//
//  Consoles.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

struct ConsoleTypes {
    static let PS4      = "PS4"
    static let PS3      = "PS3"
    static let XBOX360  = "XBOX360"
    static let XBOXONE  = "XBOXONE"
}

class Consoles {
    var consoleId: String?
    var consoleType: String?
    var verifyStatus: String?
    var isPrimary: Bool?
    var clanTag: String?
    var unverDisplayClanTag: String?
    
    
    func saveConsolesObject (consoleObj: Consoles) {
    }
    
    class func getConsoleID () -> String? {
        return nil
    }
    
    class func getConsoleType () -> String? {
        return nil
    }
    
    class func getConsoleVerifyStatus () -> String? {
        return nil
    }
    
    //Is Console Latest
    func isPlayStationConsoleLatest () -> Bool {
        if self.consoleType == ConsoleTypes.PS4 {
            return true
        }
        
        return false
    }
    
    func isXBoxConsoleLatest () -> Bool {
        if self.consoleType == ConsoleTypes.XBOXONE {
            return true
        }
        
        return false
    }
}

