//
//  GetConfigRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

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
            
            if let onBoardingScreens = swiftyJsonVar?["onBoardingScreens"] {
                self.parseAndSaveOnBoardingScreens(onBoardingScreens)
            } else {
                self.addDefaultCards()
            }
            completion(true)
        }
    }

    private func parseAndSaveOnBoardingScreens(_ onBoardingScreens:JSON) {
        if let requiredOnboardingScreens = onBoardingScreens["required"].array {
            var requiredCards = [OnBoardingCard]()
            for requiredOnboardingScreen in requiredOnboardingScreens {
                let newCard = OnBoardingCard()
                newCard.parse(json: requiredOnboardingScreen)
                requiredCards.append(newCard)
            }
            requiredCards.sort { $0.order < $1.order}
            ApplicationManager.sharedInstance.onBoardingCards.append(contentsOf: requiredCards)
        }
        if let optionalOnboardingScreens = onBoardingScreens["optional"].array {
            var optionalCards = [OnBoardingCard]()
            for optionalOnboardingScreen in optionalOnboardingScreens {
                let newCard = OnBoardingCard()
                newCard.parse(json: optionalOnboardingScreen)
                optionalCards.append(newCard)
            }
            optionalCards.sort { $0.order < $1.order}
            ApplicationManager.sharedInstance.onBoardingCards.append(contentsOf: optionalCards)
        }
    }

    private func addDefaultCards() {
        for i in 1...4 {
            let newCard = OnBoardingCard()
            let fakeview = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
            var color:UIColor!
            switch i {
            case 2:
                color = UIColor.niceBlue
            case 3:
                color = UIColor.niceGreen
            default:
                color = UIColor.tangerine
            }
            fakeview.backgroundColor = color
            newCard.backgroundImage.image = fakeview.createImageFromView()
            newCard.heroImage.image = UIImage(named:"imgHero0\(i)")
            newCard.textImage.image = UIImage(named:"imgTextCard0\(i)")
            ApplicationManager.sharedInstance.onBoardingCards.append(newCard)
        }
    }
}
