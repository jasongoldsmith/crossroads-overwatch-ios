//
//  WebView.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/30/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit


protocol WebViewProtocol {
    func backButtonPressed(sender: UIButton)
}

class WebView: UIView, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backButton: UIButton!
    var delegate:
    WebViewProtocol?
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func backButtonPressed (sender: UIButton) {
        delegate?.backButtonPressed(sender: sender)
    }
    
    func loadUrl (url: URL) {
        self.webView.loadRequest(NSURLRequest.init(url: url) as URLRequest)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("shouldStartLoadWithRequest: \(request)")
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad: \(webView.request)")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
}
