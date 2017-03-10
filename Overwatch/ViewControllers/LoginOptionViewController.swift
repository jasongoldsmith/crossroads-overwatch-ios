//
//  LoginOptionViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import iCarousel

class LoginOptionViewController: BaseViewController, iCarouselDataSource, iCarouselDelegate, CustomErrorDelegate {
    
    var items: [EventInfo] = ApplicationManager.sharedInstance.eventsList
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var carousel : iCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAndFixArrayIfNeeded()
        let countString = ApplicationManager.sharedInstance.totalUsers?.description
        let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 195/255, blue: 0/255, alpha: 1)]
        var countAttributedStr = NSAttributedString(string: countString!, attributes: stringColorAttribute)
        let helpAttributedStr = NSAttributedString(string: " heroes searching for teams", attributes: nil)
        
        if ApplicationManager.sharedInstance.totalUsers! < 1 {
            countAttributedStr = NSAttributedString(string: "", attributes: nil)
        }
        
        let finalString:NSMutableAttributedString = countAttributedStr.mutableCopy() as! NSMutableAttributedString
        finalString.append(helpAttributedStr)
        
        self.playerCountLabel.attributedText = finalString
        self.carousel?.autoscroll = -0.1
        
        let userDefaults = UserDefaults.standard
        let isUserLoggedIn =
            UserInfo.isUserLoggedIn()
        if userDefaults.bool(forKey: K.UserDefaultKey.FORCED_LOGOUT_NEW_SIGN_IN) == false && isUserLoggedIn == true {
            let errorView = Bundle.main.loadNibNamed("CustomError", owner: self, options: nil)?[0] as! CustomError
            errorView.errorMessageHeader?.text = "CHANGES TO SIGN IN"
            errorView.errorMessageDescription?.text = "Good news! You can now sign in using your Xbox or PlayStation account (the same one you use for Battle.net)"
            errorView.frame = self.view.frame
            errorView.delegate = self
            self.view.addSubview(errorView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAndFixArrayIfNeeded()
    }
    
    func okButtonPressed () {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: K.UserDefaultKey.FORCED_LOGOUT_NEW_SIGN_IN)
    }
    
    @IBAction func loginWithBattleNet(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : WebViewViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW_SIGNIN) as! WebViewViewController
        vc.consoleLoginEndPoint = K.TRUrls.TR_BaseUrl + "/api/v1/auth/login"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func LogInButtonTapped(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func signUpButtonTapped(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "signupViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
        let trackingRequest = AppTrackingRequest()
        trackingRequest.sendApplicationPushNotiTracking(notiDict: nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SIGNUP_INIT, completion: {didSucceed in
        })
    }

    @IBAction func showOnBoardingController(sender: AnyObject) {
        if ApplicationManager.sharedInstance.onBoardingCards.count != 0 {
            let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "onBoardingVC") as! OnBoardingViewController
            present(vc, animated: true, completion: nil)
        }
    }

    //MARK:- carousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView{
        var itemView: CaroselCellView
        
        //create new view if no view is available for recycling
        if (view == nil) {
            itemView = Bundle.main.loadNibNamed("CaroselCellView", owner: self, options: nil)?[0] as! CaroselCellView
        } else {
            itemView = view as! CaroselCellView
        }
        itemView.frame = CGRect(x:0, y:0, width:ScreenSize.SCREEN_WIDTH-48.0, height:carousel.frame.size.height)
        itemView.layoutIfNeeded()
        itemView.updateViewWithActivity(eventInfo: items[index])
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch (option)
        {
        case .wrap:
            return 1
        case .spacing:
            return value * 1.04
        case .visibleItems:
            return 3
        default:
            return value
        }
    }
    
    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return ScreenSize.SCREEN_WIDTH-48.0
    }

    func checkAndFixArrayIfNeeded() {
        switch items.count {
        case 1:
            guard let first = items.first else {
                break
            }
            items.append(first)
            items.append(first)
            items.append(first)
            items.append(first)
            items.append(first)
            carousel.reloadData()
        case 2:
            guard let first = items.first,
                let last = items.last else {
                    break
            }
            items.append(first)
            items.append(last)
            items.append(first)
            items.append(last)
            items.append(first)
            items.append(last)
            carousel.reloadData()
        default:
            break
        }
    }
}
