//
//  BaseViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit
//import SlideMenuControllerSwift

class BaseViewController: UIViewController {
    
    typealias viewControllerDismissed = (_ didDismiss: Bool?) -> ()
    
    var currentViewController: UIViewController?
    //    let appManager  = TRApplicationManager.sharedInstance
    let defaults    = UserDefaults.standard
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Add app state observers
        //        NotificationCenter.default.addObserver(self,
        //                                               selector: #selector(TRBaseViewController.applicationWillEnterForeground),
        //                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
        //                                               object: nil)
        //
        //
        //        NotificationCenter.default.addObserver(self,
        //                                               selector: #selector(TRBaseViewController.applicationDidEnterBackground),
        //                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
        //                                               object: nil)
        //
        //
        //        NotificationCenter.default.addObserver(self,
        //                                               selector: #selector(TRBaseViewController.didReceiveRemoteNotificationInBackGroundSession(_:)),
        //                                               name: K.NOTIFICATION_TYPE.APPLICATION_DID_RECEIVE_REMOTE_NOTIFICATION,
        //                                               object: nil)
        //
        //
        //        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.currentViewController = self
        
        //        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        //        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.currentViewController = nil
        
        //        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
    
    
    func applicationWillEnterForeground() {
        
        //        if TRUserInfo.isUserLoggedIn() == false {
        //            return
        //        }
        //
        //        if let _ = TRApplicationManager.sharedInstance.currentUser {
        //
        //            TRApplicationManager.sharedInstance.bungieVarificationHelper.shouldShowLoginSceen({ (showLoginScreen, error) in
        //
        //            }, clearBackGroundRequest: true)
        //        } else {
        //            return
        //        }
        //
        //
        //        TRApplicationManager.sharedInstance.bungieVarificationHelper.shouldShowLoginSceen({ (showLoginScreen, error) in
        //            if let _ = error {
        //                return
        //            }
        //
        //            if showLoginScreen == true {
        //                let createRequest = TRAuthenticationRequest()
        //                createRequest.logoutTRUser() { (value ) in
        //                    if value == true {
        //
        //                        self.dismissViewControllerAnimated(false, completion:{
        //                            TRUserInfo.removeUserData()
        //                            TRApplicationManager.sharedInstance.purgeSavedData()
        //
        //                            self.didMoveToParentViewController(nil)
        //                            self.removeFromParentViewController()
        //                        })
        //                    } else {
        //                        self.displayAlertWithTitle("Logout Failed", complete: { (complete) -> () in
        //                        })
        //                    }
        //                }
        //            }
        //        }, clearBackGroundRequest: false)
        //
        //
        //Add Observer to check if the user has been verified
        ApplicationManager.sharedInstance.fireBaseManager?.addUserObserverWithCompletion(complete: { (didCompelete) in
            
        })
    }
    
    func reloadEventTable () {
        
    }
    
    func applicationDidEnterBackground() {
    }
    
    
    func  applicationDidTerminate () {
        
        // Dismiss all viewController
        // Later it will load from rootview controller and will load fresh EventList VC
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: {
            self.didMove(toParentViewController: nil)
            self.removeFromParentViewController()
        })
    }
    
    func showEventDetailView (eventID: String) {
    }
    
    func activeNotificationViewClosed() {
    }
    
    func didReceiveRemoteNotificationInBackGroundSession (sender: NSNotification) {
    }
    
    func dismissViewController (isAnimated:Bool, dismissed: @escaping viewControllerDismissed) {
        
        self.dismiss(animated: isAnimated) {
            self.didMove(toParentViewController: nil)
            self.removeFromParentViewController()
            dismissed(true)
        }
    }
    
    func removeNavigationStackViewControllers () {
        
    }
    
    
    //MARK:- Navigation
    func navBackButtonPressed (sender: UIBarButtonItem?) {
        if let navController = navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func navigationButtonClosePressed (sender: UIBarButtonItem?) {
        dismissViewController(isAnimated: true, dismissed: { _ -> Void in
            self.didMove(toParentViewController: nil)
            self.removeFromParentViewController()
        })
    }
    
    deinit {
        
        //        //Remove Observers
        //        NSNotificationCenter.defaultCenter().removeObserver(UIApplicationWillEnterForegroundNotification)
        //        NSNotificationCenter.defaultCenter().removeObserver(UIApplicationDidEnterBackgroundNotification)
        //        
        //        NSNotificationCenter.defaultCenter().removeObserver(K.NOTIFICATION_TYPE.REMOTE_NOTIFICATION_WITH_ACTIVE_SESSION)
        //        NSNotificationCenter.defaultCenter().removeObserver(K.NOTIFICATION_TYPE.APPLICATION_DID_RECEIVE_REMOTE_NOTIFICATION)
        //        
        //        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
}
