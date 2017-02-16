//
//  CaroselCellView.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class CaroselCellView: UIView {
    
    
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventCheckPoint: UILabel!
    @IBOutlet weak var eventCreator: UILabel!
    @IBOutlet weak var eventDifficulty: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var playerOneIcon: UIImageView!
    @IBOutlet weak var playerTwoIcon: UIImageView!
    @IBOutlet weak var playerThreeIcon: UIImageView!
    @IBOutlet weak var playerCountLabelIcon: UILabel!
    @IBOutlet weak var checkPointHeightCont: NSLayoutConstraint!
    @IBOutlet weak var eventTagLabel        :InsertLabel?
    
    
    func updateViewWithActivity (eventInfo:
        EventInfo) {
        
        //Event Icon
        self.eventIcon.image = UIImage(named:"iconGhostDefault")
        let block: SDExternalCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
            if let anImage = image, error == nil {
                self.eventIcon.image = anImage
            } else {
                self.eventIcon.image = UIImage(named:"iconGhostDefault")
            }
        }
        if let imageURLString = eventInfo.eventActivity?.activityIconImage {
            if let url = URL(string: imageURLString) {
                self.eventIcon.sd_setImage(with: url, completed: block)
            }
        }
        
        //EventName
        self.eventName?.text = eventInfo.eventActivity?.activityType
        
        //CheckPoint
        if eventInfo.eventActivity?.activitySubType != "" &&  eventInfo.eventActivity?.activitySubType != nil{
            self.eventCheckPoint?.isHidden = false
            self.eventCheckPoint?.text = eventInfo.eventActivity?.activitySubType
        }
        
        if let eventType = eventInfo.eventActivity?.activityType {
            self.eventDifficulty?.isHidden = false
            
            switch eventType {
            case K.ActivityType.RAIDS:
                let difficultyCount = eventInfo.eventActivity?.activityDificulty == "Hard" ? "HARD" : "NORMAL"
                self.eventDifficulty?.text = difficultyCount
                break
            case K.ActivityType.CRUCIBLE:
                let vCount = (eventInfo.eventActivity?.activityMaxPlayers?.intValue)! > 3 ? "6v6" : "3v3"
                self.eventDifficulty?.text = vCount
                break
            default:
                self.eventDifficulty?.isHidden = true
            }
        }
        
        // Set  Event Player Names
        if let _ = eventInfo.eventActivity?.activityMaxPlayers,
            (eventInfo.eventPlayersArray.count < (eventInfo.eventActivity?.activityMaxPlayers?.intValue)!) {
            let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)]
            let extraPlayersRequiredCount = ((eventInfo.eventActivity?.activityMaxPlayers?.intValue)! - eventInfo.eventPlayersArray.count)
            let extraPlayersRequiredCountString = String(extraPlayersRequiredCount)
            let extraPlayersRequiredCountStringNew = " LF" + "\(extraPlayersRequiredCountString)M"
            
            // Attributed Strings
            let extraPlayersRequiredCountStringNewAttributed = NSAttributedString(string: extraPlayersRequiredCountStringNew, attributes: stringColorAttribute)
            if let _ = eventInfo.eventCreator?.playerPsnID {
                
                let finalString = NSMutableAttributedString(string: (eventInfo.eventCreator?.playerPsnID!)!)
                if var clanTag = eventInfo.eventCreator?.getDefaultConsole()?.clanTag, clanTag != "" {
                    clanTag = " " + "[" + clanTag + "]"
                    let clanAttributedStr = NSAttributedString(string: clanTag)
                    if eventInfo.eventCreator!.playerID != ApplicationManager.sharedInstance.currentUser?.userID {
                        finalString.append(clanAttributedStr)
                    } else if (UserInfo.isUserVerified()! == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                        finalString.append(clanAttributedStr)
                    }
                }
                
                finalString.append(extraPlayersRequiredCountStringNewAttributed)
                self.eventCreator.attributedText = finalString
            }
        } else {
            var playersNameString = (eventInfo.eventCreator?.playerPsnID!)!
            if var clanTag = eventInfo.eventCreator?.getDefaultConsole()?.clanTag, clanTag != "" {
                clanTag = " " + "[" + clanTag + "]"
                if eventInfo.eventCreator!.playerID != ApplicationManager.sharedInstance.currentUser?.userID {
                    playersNameString = playersNameString + clanTag
                } else if (UserInfo.isUserVerified()! == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                    playersNameString = playersNameString + clanTag
                }
            }
            
            self.eventCreator.text = playersNameString
        }
        
        //Players Icon
        self.addRadiusToPlayerIconsForPlayersArray(eventInfo: eventInfo)
        
        // Button
        self.joinButton.layer.cornerRadius = 2.0
        
        if (eventInfo.eventStatus == EVENT_STATUS.FULL.rawValue) {
            self.joinButton?.setTitle("FULL", for: .normal)
            self.joinButton?.backgroundColor = UIColor(red: 99/255, green: 182/255, blue: 32/255, alpha: 1)
        } else {
            self.joinButton?.setTitle("JOIN", for: .normal)
            self.joinButton?.backgroundColor = UIColor(red: 250/255, green: 148/255, blue: 0/255, alpha: 1)
        }
        //Event Tag
        if let hasTag = eventInfo.eventActivity?.activityTag, hasTag != "" {
            //TODO: Unhide this
            self.eventTagLabel?.isHidden = true
            self.eventTagLabel?.text = eventInfo.eventActivity?.activityTag
        } else {
            self.eventTagLabel?.isHidden = true
        }

        //Add corner radius
        self.eventTagLabel?.layer.cornerRadius = 2.0
        self.eventTagLabel?.layer.masksToBounds = true
        self.eventTagLabel?.backgroundColor = UIColor(red: 82/255, green: 100/255, blue: 139/255, alpha: 1)

        self.playerOneIcon?.roundRectView(borderWidth: 1, borderColor: UIColor.gray)
        self.playerTwoIcon?.roundRectView(borderWidth: 1, borderColor: UIColor.gray)
        self.playerThreeIcon?.roundRectView(borderWidth: 1, borderColor: UIColor.gray)
    }
    
    func addRadiusToPlayerIconsForPlayersArray (eventInfo:
        EventInfo) {
        
        self.playerOneIcon.isHidden = true
        self.playerTwoIcon.isHidden = true
        self.playerThreeIcon.isHidden = true

        let playerArray = eventInfo.eventPlayersArray
        
        for (index, player) in playerArray.enumerated() {
            switch index {
            case 0:
                
                self.playerOneIcon.isHidden = false
                
                playerOneIcon.image = UIImage(named: "avatar")
                let block: SDExternalCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                    if let anImage = image, error == nil {
                        self.playerOneIcon.image = anImage
                    } else {
                        self.playerOneIcon.image = UIImage(named:"avatar")
                    }
                }
                if let imageURLString = player.playerImageUrl {
                    if let url = URL(string: imageURLString){
                        playerOneIcon.sd_setImage(with: url, completed: block)
                    }
                }
                
                self.playerOneIcon?.roundRectView(borderWidth: 1, borderColor: UIColor.gray)
                break;
            case 1:
                
                self.playerTwoIcon.isHidden = false
                playerTwoIcon.image = UIImage(named: "avatar")
                let block: SDExternalCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                    if let anImage = image, error == nil {
                        self.playerTwoIcon.image = anImage
                    } else {
                        self.playerTwoIcon.image = UIImage(named:"avatar")
                    }
                }
                if let imageURLString = player.playerImageUrl {
                    if let url = URL(string: imageURLString){
                        playerTwoIcon.sd_setImage(with: url, completed: block)
                    }
                }
                
                self.playerTwoIcon?.roundRectView(borderWidth: 1, borderColor: UIColor.gray)
                break;
                
            case 2:
                
                self.playerThreeIcon.isHidden = false
                if((eventInfo.eventMaxPlayers?.intValue)! > 3 && eventInfo.eventPlayersArray.count > 3) {
                    self.playerThreeIcon.image = nil
                    self.playerCountLabelIcon.isHidden = false
                    self.playerCountLabelIcon?.text = "+" + String((playerArray.count - 2))
                    self.playerThreeIcon?.roundRectView(borderWidth: 1, borderColor: UIColor.gray)
                    
                } else {
                    self.playerThreeIcon.isHidden = false
                    self.playerCountLabelIcon.isHidden = true
                    playerThreeIcon.image = UIImage(named: "avatar")
                    let block: SDExternalCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                        if let anImage = image, error == nil {
                            self.playerThreeIcon.image = anImage
                        } else {
                            self.playerThreeIcon.image = UIImage(named:"avatar")
                        }
                    }
                    if let imageURLString = player.playerImageUrl {
                        if let url = URL(string: imageURLString){
                            playerThreeIcon.sd_setImage(with: url, completed: block)
                        }
                    }
                    
                    self.playerThreeIcon?.roundRectView(borderWidth: 1, borderColor: UIColor.gray)
                }
                
                break;
                
            default:
                break;
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
