//
//  ConsoleCell.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/26/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class ConsoleCell: UITableViewCell {
    
    @IBOutlet weak var consoleTitle: UILabel!

    override func prepareForReuse() {
        consoleTitle.text = ""
    }
    
}
