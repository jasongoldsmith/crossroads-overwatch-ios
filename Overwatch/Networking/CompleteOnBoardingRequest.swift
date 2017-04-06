//
//  CompleteOnBoardingRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 3/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class CompleteOnBoardingRequest: NSObject {

    class func updateCompleteOnBoarding() {
        let completeOnBoarding = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LEGAL_ACCEPTED
        let request = NetworkRequest.sharedInstance
        request.requestURL = completeOnBoarding
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let theError = error {
                print(theError)
            } else {
                print("Onboarding Cool")
            }
        }
    }
}
