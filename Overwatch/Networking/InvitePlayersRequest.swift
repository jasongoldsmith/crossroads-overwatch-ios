//
//  InvitePlayersRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/20/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class InvitePlayersRequest: NSObject {
    
    func invitePlayers (eventID: String, invitedPlayers: [String], invitationLink: String, completion:@escaping TRResponseCallBack) {
        let reportURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_INVITE_PLAYER
        var params = [String: AnyObject]()
        params["eId"] = eventID as AnyObject?
        params["invitees"] = invitedPlayers as AnyObject?
        params["invitationLink"] = invitationLink as AnyObject?
        let request = NetworkRequest.sharedInstance
        request.requestURL = reportURL
        request.params = params
        request.URLMethod = .post
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let wrappedError = error {
                completion(wrappedError, nil)
                return
            }
            completion(nil, swiftyJsonVar)
        }
    }

}
