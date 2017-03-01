//
//  RootViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {

    // Push Data
    var pushNotificationData: NSDictionary? = nil
    var branchLinkData: NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialConfigurationCall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForUserDataAndDisplayNextViewController()
        ApplicationManager.sharedInstance.fireBaseManager?.addUserObserverWithCompletion(complete: { (didCompelete) in
            
        })
    }
    
    func initialConfigurationCall(){
        let configRequest = GetConfigRequest()
        configRequest.getConfiguration(completion: { (didSucceed) in
            guard let succeed = didSucceed,
            succeed else {
                DispatchQueue.main.async {
                    self.initialConfigurationCall()
                }
                return
            }
        })
    }
    
    func checkForUserDataAndDisplayNextViewController() {
        guard let _ = ApplicationManager.sharedInstance.appConfiguration?.mixPanelToken else {
            DispatchQueue.main.async {
                self.checkForUserDataAndDisplayNextViewController()
            }
            return
        }
        if LoginHelper.sharedInstance.shouldShowLoginSceen() {
            let feedRequest = FeedRequest()
            feedRequest.getPublicFeed(completion: { (didSucceed) in
                guard let succeed = didSucceed else {
                    return
                }
                if succeed {
                    let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                    let vc : LoginOptionViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_LOGIN_OPTIONS) as! LoginOptionViewController
                    let navigationController = BaseNavigationViewController(rootViewController: vc)
                    self.present(navigationController, animated: false, completion: nil)
                } else {
                    UserInfo.removeUserData()
                    ApplicationManager.sharedInstance.purgeSavedData()
                    ApplicationManager.sharedInstance.log.debug("Failed Fetching profile")
                    self.checkForUserDataAndDisplayNextViewController()
                }
            })
        } else {
            let profileRequest = ProfileRequest()
            profileRequest.getProfile(completion: { (profileDidSucceed) in
                guard let profileSucceed = profileDidSucceed else {
                    return
                }
                if profileSucceed {
                    //Check For Consoles
                    if let _ = ApplicationManager.sharedInstance.currentUser?.getDefaultConsole(){
                        let privateFeedRequest = FeedRequest()
                        privateFeedRequest.getPrivateFeed(completion: { (didSucceed) in
                            guard let succeed = didSucceed else {
                                return
                            }
                            if succeed {
                                DispatchQueue.main.async {
                                    ApplicationManager.sharedInstance.addSlideMenuController(parentViewController: self, pushData: self.pushNotificationData, branchData: self.branchLinkData, showLandingPage: succeed, showGroups: false)
                                    self.pushNotificationData = nil
                                }
                            } else {
                                ApplicationManager.sharedInstance.log.debug("Failed Fetching Feed")
                                UserInfo.removeUserData()
                                ApplicationManager.sharedInstance.purgeSavedData()
                                ApplicationManager.sharedInstance.log.debug("Failed Fetching profile")
                                self.checkForUserDataAndDisplayNextViewController()
                            }
                        })
                    } else {
                        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "choosePlatformViewController") as! ChoosePlatformViewController
                        let navigationController = BaseNavigationViewController(rootViewController: vc)
                        self.present(navigationController, animated: true, completion: nil)
                    }
                } else {
                    UserInfo.removeUserData()
                    ApplicationManager.sharedInstance.purgeSavedData()
                    ApplicationManager.sharedInstance.log.debug("Failed Fetching profile")
                    self.checkForUserDataAndDisplayNextViewController()
                }
            })
        }
    }
}

