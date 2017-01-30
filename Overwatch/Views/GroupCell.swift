//
//  GroupCell.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var groupAvator: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var memberCount: UILabel!
    @IBOutlet weak var clanEnabled: UILabel!
    @IBOutlet weak var notificationButton: EventButton!
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.groupName.text = nil
        self.groupAvator?.image = nil
        self.memberCount?.text = nil
        self.clanEnabled?.text = nil
        self.contentView.alpha = 1
        self.contentView.isUserInteractionEnabled = true
        self.notificationButton?.isHighlighted = false
        self.memberCount.isHidden = true
        self.notificationButton.buttonGroupInfo = nil
        self.notificationButton.isHighlighted = false
    }
    
    func addNoGroupCellUI () {
        
        //Adding rounder corner for cell
        self.cornerRadius = 2.0
        self.groupAvator?.image = UIImage(named: "imgNogroups")
        self.notificationButton.isSelected = true
        self.groupName.text = "Your Overwatch Group Here"
        self.memberCount.text = "87 in Queue"
        self.memberCount.isHidden = false
        self.clanEnabled.text = "7 Activities"
    }
    
    func updateCellViewWithGroup (groupInfo: GroupInfo) {
        
        //Adding rounder corner for cell
        self.cornerRadius = 2.0
        
        if let hasImage = groupInfo.avatarPath,
            let imageUrl = URL(string: hasImage) {
            self.groupAvator?.sd_setImage(with: imageUrl)
        }
        
        self.groupName.text = groupInfo.groupName
        if let hasMembers = groupInfo.memberCount {
            self.memberCount.isHidden = false
            self.memberCount.text =  hasMembers.description + " in Queue"
        } else {
            self.memberCount.isHidden = true
        }
        
        if let eventCount = groupInfo.eventCount, eventCount > 0 {
            let activity = eventCount == 1 ? " Activity" : " Activities"
            self.clanEnabled.text = eventCount > 1 ? eventCount.description + activity : eventCount.description + activity
        } else {
            self.clanEnabled.text = "0 Activities"
        }
        
        //Add Radius
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        
        // Cell Shadow
        self.layer.shadowOffset = CGSize(width:0, height:1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.2
        self.clipsToBounds = false
        let shadowFrame: CGRect = (self.bounds)
        let shadowPath: CGPath = UIBezierPath(rect: shadowFrame).cgPath
        self.layer.shadowPath = shadowPath
        
    }
}

