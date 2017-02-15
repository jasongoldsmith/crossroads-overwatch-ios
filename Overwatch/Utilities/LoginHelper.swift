//
//  LoginHelper.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import Mixpanel

private let _sharedInstance = LoginHelper()

class LoginHelper {
    
    //MARK: Callbacks
//    typealias SignInCallBack = (_ showLoginScreen: Bool, _ error: String?) -> ()

    //MARK: Singleton Method
    class var sharedInstance: LoginHelper {
        return _sharedInstance
    }
    
    var userID: String?
    var storedCookies = [HTTPCookie]()
    
    //MARK: Methods
    func shouldShowLoginSceen() -> Bool {
        var returnValue = true
        if let cookies = NetworkRequest.sharedInstance.cookieStorage.cookies {
            for cookie in cookies {
                storedCookies.append(cookie)
            }
        }
        if let _ = UserInfo.getUserID() {
            returnValue = false
        }
        return returnValue
    }
}
