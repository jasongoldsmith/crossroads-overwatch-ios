//
//  MessageSentConfViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class MessageSentConfViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if email != "" {
            titleLabel.text = "EMAIL SENT"
            bodyLabel.text = "Check your email address at:\n\(email)\nfor a reset password link."
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func closeMessageSentConfirmation () {
        self.dismissViewController(isAnimated: true) { (didDismiss) in
            
        }
    }
    
    deinit {
        
    }
}
