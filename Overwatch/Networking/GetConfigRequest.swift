//
//  GetConfigRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class GetConfigRequest: NSObject {
    
    func getConfiguration (completion: @escaping TRValueCallBack) {
        let configuration = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CONFIGURATION
        let request = NetworkRequest.sharedInstance
        request.requestURL = configuration
        request.URLMethod = .get
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(false)
                return
            }
            
            let appConfig = ConfigInfo()
            appConfig.mixPanelToken = swiftyJsonVar?["mixpanelToken"].string
            appConfig.playerDetailsUrl = swiftyJsonVar?["playerDetailsURL"].string
            appConfig.xBoxLoginUrl = swiftyJsonVar?["xboxLoginURL"].string
            appConfig.psnLoginUrl = swiftyJsonVar?["psnLoginURL"].string
            
            
            if let _ = appConfig.playerDetailsUrl {
                UserDefaults.standard.set(appConfig.playerDetailsUrl, forKey: K.UserDefaultKey.APPLICATION_CONFIGURATIONS_PLAYER_DETAIL)
            }
            if let _ = appConfig.xBoxLoginUrl {
                UserDefaults.standard.set(appConfig.xBoxLoginUrl, forKey: K.UserDefaultKey.APPLICATION_CONFIGURATIONS_PSN_URL)
            }
            if let _ = appConfig.psnLoginUrl {
                UserDefaults.standard.set(appConfig.psnLoginUrl, forKey: K.UserDefaultKey.APPLICATION_CONFIGURATIONS_XBOX_URL)
            }
            
            ApplicationManager.sharedInstance.appConfiguration = appConfig
            request.mgr = request.configureManager()
            
            completion(true)
        }
    }

}
