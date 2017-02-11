//
//  HelmetUpdateRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/10/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class HelmetUpdateRequest: NSObject {

    typealias TRStringValueCallBack = (_ imageStringUrl: String?) -> ()

    func updateHelmetForUser (completion:@escaping TRStringValueCallBack) {
        let helmetURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_HELMET_UPDATE
        let request = NetworkRequest.sharedInstance
        request.requestURL = helmetURL
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                completion(nil)
                return
            }
            //Update User Object with the new image
            if let hamletImage = swiftyJsonVar?["value"]["imageUrl"].string,
            hamletImage != "" {
                UserInfo.setUserImageString(imageURL: hamletImage)
                completion(hamletImage)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
}
