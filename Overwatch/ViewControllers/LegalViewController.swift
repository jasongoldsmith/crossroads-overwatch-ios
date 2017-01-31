//
//  LegalViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/30/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

class LegalViewController: BaseViewController, WebViewProtocol {
    
    var linkToOpen: URL?
    var webLegalWebView:WebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webLegalWebView = Bundle.main.loadNibNamed("WebView", owner: self, options: nil)?[0] as? WebView
        self.webLegalWebView!.frame = self.view.frame
        self.view.addSubview(self.webLegalWebView!)
        
        //Set Delegate
        self.webLegalWebView!.delegate = self
        
        guard let _ = self.linkToOpen else {
            self.dismissViewController(isAnimated: true, dismissed: { (didDismiss) in
                
            })
            
            return
        }
        
        //Add link to open
        self.webLegalWebView!.loadUrl(url: self.linkToOpen!)
    }
    
    
    func backButtonPressed(sender: UIButton) {
        
        self.webLegalWebView!.delegate = nil
        self.dismissViewController(isAnimated: true) { (didDismiss) in
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
    }
    
    deinit {
        
    }
}
