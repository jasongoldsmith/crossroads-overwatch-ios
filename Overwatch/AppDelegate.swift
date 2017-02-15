//
//  AppDelegate.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import UIKit
import UserNotifications
import FBSDKCoreKit
import Firebase
import Branch
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var faceBookAdLink: Dictionary <String, String>?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard let rootController = window?.rootViewController as? RootViewController else {
            return true
        }
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary? {
            rootController.pushNotificationData = remoteNotification
        }
        let userDefaults = UserDefaults.standard
        let isInstallInfoSent = userDefaults.bool(forKey: K.UserDefaultKey.INSTALL_INFO_SENT)

        //Initialize FireBase Configuration
        ApplicationManager.sharedInstance.fireBaseManager?.initFireBaseConfig()
        
        //Initialize Answers
        Fabric.with([Branch.self, Answers.self, Crashlytics.self])

        //Facebook Init
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        Branch.getInstance().registerFacebookDeepLinkingClass(FBSDKAppLinkUtility.self)
        //Branch Initialized
        let branch: Branch = Branch.getInstance()
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
            if let isBranchLink = (params?["+clicked_branch_link"] as AnyObject).boolValue,  isBranchLink == true {
                
                // Tracking Open Source
                var mySourceDict = [String: AnyObject]()
                mySourceDict["source"] = K.SharingPlatformType.Platform_Branch as AnyObject?
                let trackingRequest = AppTrackingRequest()
                trackingRequest.sendApplicationPushNotiTracking(notiDict: mySourceDict as NSDictionary?, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_INIT, completion: {didSucceed in
                })
                
                if isInstallInfoSent == false {
                    
                    // App Install Request
                    let myInstallDict = [String: AnyObject]()
                    mySourceDict["ads"] = K.SharingPlatformType.Platform_Branch as AnyObject?
                    
                    self.appInstallRequestWithDict(installInfo: myInstallDict) { (didSucceed) in
                        if didSucceed == true {
                            
                        }
                    }
                } else {
                    var mySourceDict = [String: AnyObject]()
                    mySourceDict["source"] = K.SharingPlatformType.Platform_Branch as AnyObject?
                    self.appInitializedRequest(initInfo: mySourceDict)
                }
                
                
                let eventID = params?["eventId"] as? String
                let activityName = params?["activityName"] as? String
                
                if let inviPlayer = params?["invitees"] as? String {
                    let invi = InvitationInfo()
                    invi.eventID = eventID
                    invi.invitedPlayers = inviPlayer
                    
                    ApplicationManager.sharedInstance.invitation = invi
                }
                
                
                guard let _ = eventID else {
                    return
                }
                
                ApplicationManager.sharedInstance.addPostActionbranchDeepLink(eventID: eventID!, activityName: activityName!, params: params)
            }
        })
        
        // App Install Request
        if isInstallInfoSent == false {
            var myInstallDict = [String: AnyObject]()
            myInstallDict["ads"] = K.SharingPlatformType.Platform_Organic as AnyObject?
            
            self.appInstallRequestWithDict(installInfo: myInstallDict) { (didSucceed) in
                if didSucceed == true {
                    
                    //Send FaceBook Install Info, if avalable
                    if let _ = self.faceBookAdLink {
                        self.sendFaceBookAdsInstallInfo()
                    }
                    
                    // App Initialized Request
                    var mySourceDict = [String: AnyObject]()
                    mySourceDict["source"] = K.SharingPlatformType.Platform_UnKnown as AnyObject?
                    self.appInitializedRequest(initInfo: mySourceDict)
                }
            }
        } else {
            // App Initialized Request
            var mySourceDict = [String: AnyObject]()
            mySourceDict["source"] = K.SharingPlatformType.Platform_UnKnown as AnyObject?
            self.appInitializedRequest(initInfo: mySourceDict)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // Tracking App Init
        let trackingRequest = AppTrackingRequest()
        trackingRequest.sendApplicationPushNotiTracking(notiDict: nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_RESUME, completion: {didSucceed in
        })
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        FBSDKAppLinkUtility.fetchDeferredAppLink({ (URL, error) -> Void in
            if error != nil {
            }
            if URL != nil {
                
                let urlString = URL?.absoluteString
                let deepLinkObj = DeepLinkObject(link: urlString!)
                let deepLinkAnalyticsDict = deepLinkObj.createLinkInfoAndPassToBackEnd()
                
                if let _ = deepLinkAnalyticsDict {
                    self.faceBookAdLink = deepLinkAnalyticsDict
                }
            }
        })
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK:- Notifications
    func addNotificationsPermission () {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let deviceTokenRequest = DeviceTokenRequest()
        deviceTokenRequest.sendDeviceToken(deviceTokenString, completion: { (value) -> () in
            if let wrappedValue = value,
                wrappedValue == true {
                print("Device token registration Success")
            } else {
                print("Device token registration failed")
            }
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }

//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        // pass the url to the handle deep link call
//        if (Branch.getInstance().handleDeepLink(url)) {
//            var mySourceDict = [String: AnyObject]()
//            mySourceDict["source"] = K.SharingPlatformType.Platform_Branch as AnyObject?
//            self.appInitializedRequest(initInfo: mySourceDict)
//        }
//        
//        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
//        return true
//    }
    
    // MARK:- Branch Deep Linking related methods
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // pass the url to the handle deep link call
        if (Branch.getInstance().handleDeepLink(url)) {
            var mySourceDict = [String: AnyObject]()
            mySourceDict["source"] = K.SharingPlatformType.Platform_Branch as AnyObject?
            self.appInitializedRequest(initInfo: mySourceDict)
        }
        
        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
        let isHandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String!, annotation: options[.annotation])
        return isHandled
    }
    
    // Respond to Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // For Branch to detect when a Universal Link is clicked
        return Branch.getInstance().continue(userActivity)
    }

    //MARK:- App Data Requests
    func appInitializedRequest (initInfo: Dictionary<String, AnyObject>) {
        let trackingRequest = AppTrackingRequest()
        trackingRequest.sendApplicationPushNotiTracking(notiDict: initInfo as NSDictionary?, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_INIT, completion: {didSucceed in
        })
    }
    
    func appInstallRequestWithDict (installInfo: Dictionary<String, AnyObject>, completion: @escaping TRValueCallBack) {
        let trackingRequest = AppTrackingRequest()
        trackingRequest.sendApplicationPushNotiTracking(notiDict: installInfo as NSDictionary?, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_INSTALL, completion: {didSucceed in
            if let succeed = didSucceed,
                succeed {
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: K.UserDefaultKey.INSTALL_INFO_SENT)
                userDefaults.synchronize()
                
                completion(true)
            }
        })
    }
    
    func sendFaceBookAdsInstallInfo () {
        guard let _ = ApplicationManager.sharedInstance.appConfiguration?.mixPanelToken else {
            DispatchQueue.main.async {
                self.sendFaceBookAdsInstallInfo()
            }
            return
        }
        if let _ = self.faceBookAdLink {
            self.appInstallRequestWithDict(installInfo: self.faceBookAdLink! as Dictionary<String, AnyObject>) { (didSucceed) in
                if didSucceed == true {
                    
                }
            }
        }
    }
}

