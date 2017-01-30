//
//  EventButton.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

class EventButton: UIButton {
    
    var buttonEventInfo     : EventInfo?
    var buttonActivityInfo  : ActivityInfo?
    var buttonPlayerInfo    : PlayerInfo?
    var buttonGroupInfo     : GroupInfo?
    var activityTypeString  : Activity_Type?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
