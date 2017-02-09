//
//  UserInfo.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserInfo: NSObject {
    
    var verifyStatus    :String?
    var userName        :String?
    var password        :String?
    var userID          :String?
    var userImageURL    :String?
    var userClanID      :String?
    var psnID           :String?
    var email           :String?
    var legalInfo       :LegalInfo?
    var consoles        :[Consoles] = []
    var bungieMemberShipID: String?
    var userVerified  : String?
    var commentsReported: Int?
    var hasReachedMaxReportedComments: Bool?
    var isInvited : Bool?
    
    
    func parseUserResponse (responseObject: JSON) {
        self.userName       = responseObject["value"]["battleTag"].stringValue
        self.userID         = responseObject["value"]["_id"].stringValue
        self.email          = responseObject["value"]["email"].string
        self.userImageURL   = responseObject["value"]["imageUrl"].stringValue
        self.userClanID     = responseObject["value"]["clanId"].stringValue
        self.bungieMemberShipID = responseObject["value"]["bungieMemberShipId"].stringValue
        self.userVerified     = responseObject["value"]["verifyStatus"].stringValue
        self.commentsReported = responseObject["value"]["commentsReported"].intValue
        self.hasReachedMaxReportedComments = responseObject["value"]["hasReachedMaxReportedComments"].boolValue
        self.isInvited    = responseObject["value"]["isInvited"].boolValue
        
        // Legal Info
        if let legalDict = responseObject["value"]["legal"].dictionary {
            let legalObject = LegalInfo()
            legalObject.parseLegalObjectDictionary(responseObject: JSON(legalDict))
            self.legalInfo = legalObject
        }
        
        //Console Info
        let consoles = responseObject["value"]["consoles"].arrayValue
        for consoleObj in consoles {
            let console = Consoles()
            console.consoleId = consoleObj["consoleId"].stringValue
            console.consoleType = consoleObj["consoleType"].stringValue
            console.verifyStatus = consoleObj["verifyStatus"].stringValue
            console.isPrimary    = consoleObj["isPrimary"].bool
            console.unverDisplayClanTag = consoleObj["clanTag"].stringValue
            console.clanTag = consoleObj["clanTag"].stringValue
            
            
            //Save user console in NSUserDefaults if this is the current console
            if console.isPrimary == true && self.userID == UserInfo.getUserID() {
                self.userName = console.consoleId
                UserInfo.saveConsolesObject(consoleObj: console)
            }
            
            self.consoles.append(console)
        }
    }
    
    //Some lagacy code... :(
    func parseUserResponseWithOutValueKey (responseObject: JSON) {
        self.userName       = responseObject["userName"].stringValue
        self.userID         = responseObject["_id"].stringValue
        self.userImageURL   = responseObject["imageUrl"].stringValue
        self.userClanID     = responseObject["clanId"].stringValue
        self.bungieMemberShipID = responseObject["bungieMemberShipId"].stringValue
        self.userVerified     = responseObject["verifyStatus"].stringValue
        self.commentsReported = responseObject["commentsReported"].intValue
        self.hasReachedMaxReportedComments = responseObject["value"]["hasReachedMaxReportedComments"].boolValue
        self.isInvited    = responseObject["isInvited"].boolValue
        
        // Legal Info
        if let legalDict = responseObject["legal"].dictionary {
            let legalObject = LegalInfo()
            legalObject.parseLegalObjectDictionary(responseObject: JSON(legalDict))
            self.legalInfo = legalObject
        }
        
        //Console Info
        let consoles = responseObject["consoles"].arrayValue
        for consoleObj in consoles {
            let console = Consoles()
            console.consoleId = consoleObj["consoleId"].stringValue
            console.consoleType = consoleObj["consoleType"].stringValue
            console.verifyStatus = consoleObj["verifyStatus"].stringValue
            console.isPrimary    = consoleObj["isPrimary"].bool
            console.clanTag      = consoleObj["clanTag"].stringValue
            console.unverDisplayClanTag = consoleObj["clanTag"].stringValue
            console.clanTag = consoleObj["clanTag"].stringValue
            
            
            //Save user console in NSUserDefaults if this is the current console
            if console.isPrimary == true && self.userID == UserInfo.getUserID() {
                UserInfo.saveConsolesObject(consoleObj: console)
            }
            
            self.consoles.append(console)
        }
    }
    
    func getDefaultConsole () -> Consoles? {
        let currentConsole = self.consoles.filter{$0.isPrimary == true}
        
        if let _ = currentConsole.first {
            return currentConsole.first!
        }
        
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // User Defaults
    
    class func saveConsolesObject (consoleObj: Consoles) {
    }
    
    class func saveUserData (userData:UserInfo?) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(userData?.userName, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserName)
        userDefaults.setValue(userData?.userImageURL  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE)
        userDefaults.setValue(userData?.userClanID  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID)
        userDefaults.setValue(userData?.userID, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_UserID)
        userDefaults.setValue(userData?.bungieMemberShipID, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID)
        
        userDefaults.synchronize()
        
        ApplicationManager.sharedInstance.currentUser = userData
    }
    
    
    class func isCurrentUserEventCreator (event: EventInfo) -> Bool {
        let userDefaults = UserDefaults.standard
        if ((userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_UserID) as AnyObject).string == event.eventCreator?.playerID)  {
            return true
        }
        
        return false
    }
    
    class func isUserLoggedIn () -> Bool {
        
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            //Cookie Not Found
            return false
        }
        
        var cookieCount = 0
        for cookie in cookies {
            if cookie.name == "bungleatk" {
                cookieCount += 1
            } else if cookie.name == "bungledid" {
                cookieCount += 1
            } else if cookie.name == "bungled" {
                cookieCount += 1
            }
        }
        
        if cookieCount == 3 {
            return true
        }
        
        return false
    }
    
    class func getUserName() -> String? {
        
        let userDefaults = UserDefaults.standard
        if let userName = userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_UserName) as? String {
            return userName
        }
        return nil
    }
    
    class func getUserID() -> String? {
        let userDefaults = UserDefaults.standard
        if let userID = userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_UserID) as? String {
            return userID
        }
        
        return nil
    }
    
    class func getUserImageString() -> String? {
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE) != nil) {
            let userImageUrl = userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE) as! String
            
            return userImageUrl
        }
        
        let currentUser = ApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()
        guard let currentUserImage = currentUser?.playerImageUrl else {
            return nil
        }
        
        return currentUserImage
    }
    
    class func setUserImageString (imageURL: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(imageURL  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE)
        userDefaults.synchronize()
    }
    
    class func getUserClanID () -> String? {
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID) != nil) {
            let userClanID = userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID) as! String
            
            return userClanID
        }
        
        return nil
    }
    
    // Is Verified
    class func isUserVerified () -> String? {
        
        return ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue
//        
//        let userDefaults = UserDefaults.standard
//        
//        if let verification = userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED) as? String {
//            return verification
//        }
//        
//        return nil
    }
    
    
    // ************************************//
    // ************************************//
    // ************************************//
    // These are saved from Bungie User Authentication response. Used as params for SignUp flow. Singup response sends an array of Console (Array) Objects
    // whete this data is finally saved. A person can have multiple consoles, hence an array.
    
    
    //CONSOLE ID is the user's xbox gamertag or playstation ID
    class func saveConsoleID (bungieAccount: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(bungieAccount , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID)
        
        
        //Hardcoding it here, since user verification has begun
        userDefaults.setValue(ACCOUNT_VERIFICATION.USER_VER_INITIATED.rawValue, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED)
        
        userDefaults.synchronize()
    }
    
    class func getConsoleID() -> String? {
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) != nil) {
            return userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) as? String
        }
        
        return nil
    }
    
    // BUNGIE MEMBER_SHIP ID
    class func saveBungieMemberShipId (memberShipID: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(memberShipID , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID)
        userDefaults.synchronize()
    }
    
    class func getBungieMembershipID () -> String? {
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID) != nil) {
            return userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID) as? String
        }
        
        return nil
    }
    
    // CONSOLE TYPE
    class func saveConsoleType (consoleType: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(consoleType , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE)
        userDefaults.synchronize()
    }
    
    class func getConsoleType () -> String? {
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) != nil) {
            return userDefaults.object(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) as? String
        }
        
        return nil
    }
    
    class func removeUserData () {
        
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID)
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE)
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED)
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKey.UserAccountInfo.TR_UserName)
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE)
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID)
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKey.UserAccountInfo.TR_UserID)
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID)
        
        
        let cookieStorage = HTTPCookieStorage.shared
        guard let cookies = cookieStorage.cookies else {
            //Cookie Not Found
            return
        }
        
        for cookie in cookies {
            cookieStorage.deleteCookie(cookie)
        }
    }
}

