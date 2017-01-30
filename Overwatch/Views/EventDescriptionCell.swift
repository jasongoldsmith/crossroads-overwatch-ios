//
//  EventDescriptionCell.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class EventDescriptionCell: UITableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.blueBarView.isHidden = true
    }
    
    @IBOutlet weak var playerIcon: UIImageView!
    @IBOutlet weak var playerUserName: UILabel!
    @IBOutlet weak var playerInviteButton: UIButton!
    @IBOutlet weak var creatorDogTag: UIImageView!
    @IBOutlet weak var invitationButton: EventButton!
    @IBOutlet weak var blueBarView: UIView!
}
