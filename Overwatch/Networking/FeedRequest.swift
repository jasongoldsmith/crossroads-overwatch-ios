//
//  FeedRequest.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/19/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class FeedRequest: NSObject {
    
    func getPrivateFeed (completion: @escaping TRValueCallBack) {

        let feedURL = K.TRUrls.TR_BaseUrl + "/api/v1/feed/get"
        
        let request = NetworkRequest.sharedInstance
        request.requestURL = feedURL
        request.URLMethod = .get
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            print(swiftyJsonVar!)
            if let _ = error {
                completion(false)
                return
            }
            
            //Clear the array before fetting
            ApplicationManager.sharedInstance.eventsList.removeAll()
            ApplicationManager.sharedInstance.eventsListActivity.removeAll()
            ApplicationManager.sharedInstance.myCurrentEvents.removeAll()
            ApplicationManager.sharedInstance.myFutureEvents.removeAll()
            
            for events in (swiftyJsonVar?["currentEvents"].arrayValue)! {
                let eventInfo = EventInfo().parseCreateEventInfoObject(swiftyJason: events)
                ApplicationManager.sharedInstance.eventsList.append(eventInfo)
            }
            
            for events in (swiftyJsonVar?["futureEvents"].arrayValue)! {
                let eventInfo = EventInfo().parseCreateEventInfoObject(swiftyJason: events)
                ApplicationManager.sharedInstance.eventsList.append(eventInfo)
            }
            
            for events in (swiftyJsonVar?["adActivities"].arrayValue)! {
                let activityInfo = ActivityInfo().parseAndCreateActivityObject(swiftyJson: events)
                ApplicationManager.sharedInstance.eventsListActivity.append(activityInfo)
            }
            
            for events in (swiftyJsonVar?["myFutureEvents"].arrayValue)! {
                let activityInfo = ActivityInfo().parseAndCreateActivityObject(swiftyJson: events)
                ApplicationManager.sharedInstance.myFutureEvents.append(activityInfo)
            }
            
            for events in (swiftyJsonVar?["myCurrentEvents"].arrayValue)! {
                let activityInfo = ActivityInfo().parseAndCreateActivityObject(swiftyJson: events)
                ApplicationManager.sharedInstance.myCurrentEvents.append(activityInfo)
            }

            if let hasRating = swiftyJsonVar?["reviewPromptCard"] {
                let ratingInfo = RatingAppModel()
                ratingInfo.createRatingInfoObj(ratingInfo: hasRating)
                
                ApplicationManager.sharedInstance.ratingInfo = ratingInfo
            } else {
                ApplicationManager.sharedInstance.ratingInfo = nil
            }

            ApplicationManager.sharedInstance.totalUsers = swiftyJsonVar?["totalUsers"].intValue
            
            completion(true )
        }
    }
    
    func getPublicFeed (completion: @escaping TRValueCallBack) {
        
        let feedURL = K.TRUrls.TR_BaseUrl + "/api/v1/feed/get"
        
        let request = NetworkRequest.sharedInstance
        request.requestURL = feedURL
        request.URLMethod = .get
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            print(swiftyJsonVar!)
            if let _ = error {
                completion(false)
                return
            }
            
            //Clear the array before fetting
            ApplicationManager.sharedInstance.eventsList.removeAll()
            ApplicationManager.sharedInstance.eventsListActivity.removeAll()
            
            for events in (swiftyJsonVar?["currentEvents"].arrayValue)! {
                let eventInfo = EventInfo().parseCreateEventInfoObject(swiftyJason: events)
                if  eventInfo.eventStatus != EVENT_STATUS.FULL.rawValue {
                    ApplicationManager.sharedInstance.eventsList.append(eventInfo)
                }
            }
            
            for events in (swiftyJsonVar?["futureEvents"].arrayValue)! {
                let eventInfo = EventInfo().parseCreateEventInfoObject(swiftyJason: events)
                ApplicationManager.sharedInstance.eventsList.append(eventInfo)
            }
            
            for events in (swiftyJsonVar?["adActivities"].arrayValue)! {
                let activityInfo = ActivityInfo().parseAndCreateActivityObject(swiftyJson: events)
                ApplicationManager.sharedInstance.eventsListActivity.append(activityInfo)
            }
            
            for events in (swiftyJsonVar?["myFutureEvents"].arrayValue)! {
                let activityInfo = ActivityInfo().parseAndCreateActivityObject(swiftyJson: events)
                ApplicationManager.sharedInstance.myFutureEvents.append(activityInfo)
            }
            
            for events in (swiftyJsonVar?["myCurrentEvents"].arrayValue)! {
                let activityInfo = ActivityInfo().parseAndCreateActivityObject(swiftyJson: events)
                ApplicationManager.sharedInstance.myCurrentEvents.append(activityInfo)
            }
            
            if let hasRating = swiftyJsonVar?["reviewPromptCard"] {
                let ratingInfo = RatingAppModel()
                ratingInfo.createRatingInfoObj(ratingInfo: hasRating)
                
                ApplicationManager.sharedInstance.ratingInfo = ratingInfo
            } else {
                ApplicationManager.sharedInstance.ratingInfo = nil
            }
            
            ApplicationManager.sharedInstance.totalUsers = swiftyJsonVar?["totalUsers"].intValue
            
            completion(true )
        }
    }
}
