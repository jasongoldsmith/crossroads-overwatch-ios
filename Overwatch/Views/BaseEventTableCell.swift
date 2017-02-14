//
//  BaseEventTableCell.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

class BaseEventTableCell: UITableViewCell {
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.playerImageOne.image = nil
        self.playerImageTwo.image = nil
        self.playerCountLabel.text = nil
        self.playerCountImage.image = nil
        self.playerImageOne.isHidden = true
        self.playerImageTwo.isHidden = true
        self.playerCountLabel.isHidden = true
        self.playerCountImage.isHidden = true
        self.eventTimeLabel?.isHidden = true
        self.activityCheckPointLabel?.text = nil
        self.activityCheckPointLabel?.isHidden = true
        self.eventTagLabel?.text = nil
        self.activityLight?.isHidden = true
    }
    
    @IBOutlet weak var eventIcon            :UIImageView?
    @IBOutlet weak var eventTitle           :UILabel?
    @IBOutlet weak var activityLight        :UILabel?
    @IBOutlet weak var eventPlayersName     :UILabel!
    @IBOutlet weak var playerImageOne       :UIImageView!
    @IBOutlet weak var playerImageTwo       :UIImageView!
    @IBOutlet weak var playerCountImage     :UIImageView!
    @IBOutlet weak var playerCountLabel     :UILabel!
    @IBOutlet weak var joinEventButton      :EventButton!
    @IBOutlet weak var leaveEventButton     :EventButton!
    @IBOutlet weak var activityCheckPointLabel : UILabel?
    @IBOutlet weak var eventTimeLabel       :UILabel?
    @IBOutlet weak var eventTagLabel        :InsertLabel?
    
    func updateCellViewWithEvent (eventInfo: EventInfo) {
        
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            eventTitle?.font = UIFont(name:"HelveticaNeue", size: 17)
        }
        
        //Adding Radius to
        self.addRadiusToPlayerIconsForPlayersArray(eventInfo: eventInfo)
        self.eventTitle?.text = eventInfo.eventActivity?.activityType
        
        //Event Tag
        if let hasTag = eventInfo.eventActivity?.activityTag, hasTag != "" {
            self.eventTagLabel?.isHidden = false
            self.eventTagLabel?.text = eventInfo.eventActivity?.activityTag
        } else {
            self.eventTagLabel?.isHidden = true
        }
        
        //Add corner radius
        self.eventTagLabel?.layer.cornerRadius = 2.0
        self.eventTagLabel?.layer.masksToBounds = true
        self.eventTagLabel?.backgroundColor = UIColor(red: 82/255, green: 100/255, blue: 139/255, alpha: 1)
        
        if let eventType = eventInfo.eventActivity?.activityType {
            self.activityLight?.isHidden = false
            
            switch eventType {
            case K.ActivityType.RAIDS:
                let difficultyCount = eventInfo.eventActivity?.activityDificulty == "Hard" ? "HARD" : "NORMAL"
                self.activityLight?.text = difficultyCount
                break
            case K.ActivityType.CRUCIBLE:
                let vCount = (eventInfo.eventActivity?.activityMaxPlayers?.intValue)! > 3 ? "6v6" : "3v3"
                self.activityLight?.text = vCount
                break
            default:
                self.activityLight?.isHidden = true
            }
        }
        
        /*
         if let _ = eventInfo.eventActivity?.activityLight?.intValue where eventInfo.eventActivity?.activityLight?.intValue > 0 {
         
         let fontStarIcon = "\u{02726}"
         self.activityLight?.text = fontStarIcon + (eventInfo.eventActivity?.activityLight?.stringValue)!
         self.activityLight?.isHidden = false
         } else {
         
         guard let _ = eventInfo.eventActivity?.activityLevel else {
         self.activityLight?.isHidden = false
         return
         }
         
         self.activityLight?.isHidden = false
         
         let lvlString = "lvl "
         let stringFontAttribute = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15)!]
         
         let levelAttributedStr = NSAttributedString(string: lvlString, attributes: stringFontAttribute)
         let activityLevelAttributedStr = NSAttributedString(string: (eventInfo.eventActivity?.activityLevel)!, attributes: nil)
         
         let finalString:NSMutableAttributedString = levelAttributedStr.mutableCopy() as! NSMutableAttributedString
         finalString.appendAttributedString(activityLevelAttributedStr)
         
         self.activityLight?.attributedText = finalString
         }
         */
        
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
                self.eventPlayersName.attributedText = finalString
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
            
            self.eventPlayersName.text = playersNameString
        }
        
        // Set Event Icon Image
        if let imageURLString = eventInfo.eventActivity?.activityIconImage,
            let url = URL(string: imageURLString) {
            self.eventIcon?.sd_setImage(with: url, placeholderImage: UIImage(named: "iconGhostDefault"))
        }
        
        // Set Event Button Status
        self.eventButtonStatusForCurrentPlayer(event: eventInfo, button: self.joinEventButton)
        
        if let hasLaunchDate = eventInfo.eventLaunchDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let eventDate = formatter.date(from: hasLaunchDate) {
                let nextFormatter = DateFormatter()
                if eventDate.daysFrom(date: Date()) < 7 {
                    nextFormatter.dateFormat = "EEEE 'at' h:mm a"
                    let time = nextFormatter.string(from: eventDate)
                    self.eventTimeLabel?.text = "\(time)"
                } else {
                    nextFormatter.dateFormat = "MMM d 'at' h:mm a"
                    let time = nextFormatter.string(from: eventDate)
                    self.eventTimeLabel?.text = "\(time)"
                }
            }
        }
        
        if eventInfo.eventActivity?.activitySubType != "" &&  eventInfo.eventActivity?.activitySubType != nil{
            self.activityCheckPointLabel?.isHidden = false
            self.activityCheckPointLabel?.text = eventInfo.eventActivity?.activitySubType
        }
    }
    
    func addRadiusToPlayerIconsForPlayersArray (eventInfo: EventInfo) {
        
        let playerArray = eventInfo.eventPlayersArray
        
        for (index, player) in playerArray.enumerated() {
            switch index {
            case 0:
                
                self.playerImageOne.isHidden = false
                self.playerImageOne?.roundRectView(borderWidth: 1, borderColor: UIColor.gray)
                self.playerImageOne.image = UIImage(named: "avatar")
                if let imageURLString = player.playerImageUrl,
                    imageURLString != "",
                    let url = URL(string: imageURLString) {
                    self.playerImageOne.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))
                }
                
                break;
            case 1:
                
                self.playerImageTwo.isHidden = false
                self.playerImageTwo?.roundRectView(borderWidth: 1, borderColor: UIColor.gray
                )
                
                self.playerImageTwo.image = UIImage(named: "avatar")
                if let imageURLString = player.playerImageUrl,
                    imageURLString != "",
                    let url = URL(string: imageURLString) {
                    self.playerImageTwo.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))
                }
                
                break;
                
            case 2:
                
                self.playerCountImage.isHidden = false
                if((eventInfo.eventMaxPlayers?.intValue)! > 3 && eventInfo.eventPlayersArray.count > 3) {
                    self.playerCountImage.image = nil
                    self.playerCountLabel.isHidden = false
                    self.playerCountLabel?.text = "+" + String((playerArray.count - 2))
                    self.playerCountImage?.roundRectView(borderWidth: 1, borderColor: UIColor.gray)
                    
                } else {
                    self.playerCountLabel.isHidden = true
                    self.playerCountImage?.roundRectView(borderWidth: 1, borderColor: UIColor.gray)
                    
                    self.playerCountImage.image = UIImage(named: "avatar")
                    if let imageURLString = player.playerImageUrl,
                        imageURLString != "",
                        let url = URL(string: imageURLString) {
                        self.playerCountImage.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))
                    }
                }
                
                break;
                
            default:
                break;
            }
        }
    }
    
    func eventButtonStatusForCurrentPlayer (event: EventInfo, button: EventButton) {
        
        button.isUserInteractionEnabled = true
        var currentPlayer: PlayerInfo?
        let currentLoggedInUser = event.eventPlayersArray.filter{$0.playerID == ApplicationManager.sharedInstance.currentUser?.userID!}
        if let _ = currentLoggedInUser.first {
            currentPlayer = currentLoggedInUser.first
        }
        
        if (event.eventCreator?.playerID == UserInfo.getUserID()) {
            button.setImage(UIImage(named: "btnOWNER"), for: .normal)
            button.isUserInteractionEnabled = false
            leaveEventButton.isHidden = false
            
            return
        }
        
        if (event.eventStatus == EVENT_STATUS.FULL.rawValue) {
            if(ApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event: event)) {
                button.setImage(UIImage(named: "btnREADY"), for: .normal)
                button.isUserInteractionEnabled = false
                leaveEventButton.isHidden = false
                //                completion(value: true)
            } else {
                button.setImage(UIImage(named: "btnFULL"), for: .normal)
                button.isUserInteractionEnabled = false
                leaveEventButton.isHidden = true
            }
            
        } else if (event.eventStatus == EVENT_STATUS.NEW.rawValue) {
            if (ApplicationManager.sharedInstance.isCurrentPlayerCreatorOfTheEvent(event: event)) {
                
                if currentPlayer?.isInvited == true {
                    button.setImage(UIImage(named: "btnINVITED"), for: .normal)
                } else {
                    button.setImage(UIImage(named: "btnGOING"), for: .normal)
                }
                
                button.isUserInteractionEnabled = false
                leaveEventButton.isHidden = false
            } else {
                button.setImage(UIImage(named: "btnJOIN"), for: .normal)
                leaveEventButton.isHidden = true
            }
            
        } else if (event.eventStatus == EVENT_STATUS.OPEN.rawValue) {
            if (ApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event: event)) {
                
                if currentPlayer?.isInvited == true {
                    button.setImage(UIImage(named: "btnINVITED"), for: .normal)
                } else {
                    button.setImage(UIImage(named: "btnGOING"), for: .normal)
                }
                
                button.isUserInteractionEnabled = false
                leaveEventButton.isHidden = false
            } else {
                button.setImage(UIImage(named: "btnJOIN"), for: .normal)
                leaveEventButton.isHidden = true
            }
        } else {
            //CAN_JOIN
            if (ApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event: event)) {
                
                if currentPlayer?.isInvited == true {
                    button.setImage(UIImage(named: "btnINVITED"), for: .normal)
                } else {
                    button.setImage(UIImage(named: "btnGOING"), for: .normal)
                }
                
                button.isUserInteractionEnabled = false
                leaveEventButton.isHidden = false
            } else {
                button.setImage(UIImage(named: "btnJOIN"), for: .normal)
                leaveEventButton.isHidden = true
            }
        }
    }
}
