//
//  EventActivityCardCell.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

class EventActivityCardCell: UITableViewCell {
    
    var activityInfo: ActivityInfo?
    
    @IBOutlet weak var cellBackgroundImageView: UIImageView!
    @IBOutlet weak var cellActivityIconImageView: UIImageView!
    @IBOutlet weak var cellActivityNameLabel: UILabel!
    @IBOutlet weak var cellActivityCheckPointLabel: UILabel!
    @IBOutlet weak var cellActivityAddButton: EventButton!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.cellBackgroundImageView.image = nil
        self.cellActivityIconImageView.image = nil
        self.cellActivityNameLabel.text = nil
        self.cellActivityCheckPointLabel.text = nil
        self.cellActivityAddButton?.buttonActivityInfo = nil
    }
    
    func loadCellView () {
        
        guard let _ = self.activityInfo else {
            return
        }
        
        if let hasBGImage = self.activityInfo?.activityAdCard?.adCardImageURL, activityInfo?.activityAdCard?.adCardBaseUrl != "" {
            let imageString = (self.activityInfo?.activityAdCard?.adCardBaseUrl!)! + hasBGImage
            if let imageURL = URL(string: imageString) {
                cellBackgroundImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "imgCardBg"))
            }
        }
        
        if let iconImageString = self.activityInfo?.activityIconImage {
            if let imageURL = URL(string: iconImageString) {
                cellActivityIconImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "iconGhostDefault"))
            }
        }
        
        self.cellActivityNameLabel.text = self.activityInfo?.activityAdCard?.adCardCardHeader
        self.cellActivityCheckPointLabel.text = self.activityInfo?.activityAdCard?.adCardSubHeader
    }
}
