//
//  WebViewViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/17/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class WebViewViewController: BaseViewController, UIWebViewDelegate, CustomErrorDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var consoleLoginEndPoint: String?
    let hostName =  K.TRUrls.TR_BaseUrl.replacingOccurrences(of: "https://", with: "")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addNavigationBarButtons(showBack: true, showCancel: false)
        
        let loginRequest = NSURLRequest(url: NSURL(string: consoleLoginEndPoint!)! as URL)
        webView.loadRequest(loginRequest as URLRequest)
        webView.delegate = self
        
        
        let navBarAttributesDictionary: [String: AnyObject]? = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-3.0, for: .default)
        NotificationCenter.default.addObserver(self, selector: #selector(WebViewViewController.dismissView), name: NSNotification.Name(rawValue: K.NOTIFICATION_TYPE.USER_DATA_RECEIVED_CLOSE_WEBVIEW), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    override func navBackButtonPressed(sender: UIBarButtonItem?) {
        
        webView.stopLoading()
        if let navController = navigationController {
            navController.popViewController(animated: true)
            navController.navigationBar.isHidden = true
        }
    }
    
    func loadUrl (url: NSURL) {
        webView.loadRequest(NSURLRequest.init(url: url as URL) as URLRequest)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if webView.request?.url?.host == hostName || webView.request?.url?.host == nil {
            webView.isHidden = true
        } else {
            webView.isHidden = false
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if let url = webView.request?.url,
            url.host == hostName
        {
            webView.isHidden = true
            if validatePathComponents(url.pathComponents) {
                validateCookies()
            } else {
                navBackButtonPressed(sender: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    ApplicationManager.sharedInstance.addErrorSubViewWithTitle("BATTLE.NET ERROR", andMessage:"Please go to Battle.net and verify your account before linking it to Crossroads.")
                }
            }
        } else {
            webView.isHidden = false
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Error: \(error)")
    }
    
    func dismissView() {
        dismissViewController(isAnimated: true, dismissed: { (didDismiss) in
            
        })
    }
    
    func validateCookies() {
        let loginSucceed = !LoginHelper.sharedInstance.shouldShowLoginSceen()
        if !loginSucceed {
            UserInfo.removeUserData()
            ApplicationManager.sharedInstance.purgeSavedData()
            navBackButtonPressed(sender: nil)
        } else {
            self.dismissView()
        }
    }
    
    func okButtonPressed () {
        dismissView()
    }
    
    func validatePathComponents(_ pathComponents:[String]) -> Bool {
        for component in pathComponents {
            if component == "failure" {
                //remove all the cookies except our cookies
                let cookieStorage = HTTPCookieStorage.shared
                if let cookies = cookieStorage.cookies {
                    for cookie in cookies {
                        if cookie.domain.range(of:hostName) == nil{
                            cookieStorage.deleteCookie(cookie)
                        }
                    }
                }
                return false
            }
        }
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("DEINIT - WebViewViewController")
    }
}
