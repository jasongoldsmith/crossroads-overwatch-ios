//
//  MessageSentConfViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/2/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class MessageSentConfViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
