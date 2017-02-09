//
//  EventCommentCell.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class EventCommentCell: UITableViewCell {
    @IBOutlet weak var playerIcon: UIImageView!
    @IBOutlet weak var playerUserName: UILabel!
    @IBOutlet weak var playerComment: UILabel!
    @IBOutlet weak var messageTimeLabel: UILabel!
    @IBOutlet weak var creatorDogTag: UIImageView!
    @IBOutlet weak var messageTopConst: NSLayoutConstraint!
    @IBOutlet weak var messageBottomConst: NSLayoutConstraint!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.creatorDogTag.isHidden = true
    }
}
