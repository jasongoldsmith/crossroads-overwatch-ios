//
//  CreateEventViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


class CreateEventViewController: BaseViewController {
    
    @IBOutlet var activityIcon          : UIImageView?
    @IBOutlet var activityQuickPlay : EventButton?
    @IBOutlet var activityArcade     : EventButton?
    @IBOutlet var activityCompetitive    : EventButton?
    @IBOutlet var activityPlayVsAI : EventButton?
    @IBOutlet var activityCustomGame   : EventButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
        
        self.activityQuickPlay?.activityTypeString = Activity_Type.QUICK
        self.activityArcade?.activityTypeString = Activity_Type.ARCADE
        self.activityCompetitive?.activityTypeString = Activity_Type.COMPETITIVE
        self.activityPlayVsAI?.activityTypeString = Activity_Type.PLAYVSAI
        self.activityCustomGame?.activityTypeString = Activity_Type.CUSTOM
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func activityButtonPressed (sender: EventButton) {
        let createEventRequest = CreateEventRequest()
        createEventRequest.getTheListEvents(with: sender.activityTypeString!.rawValue, completion: { (didSucceed) in
            guard let succeed = didSucceed else {
                return
            }
            if succeed {
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : CreateEventFinalView = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CREATE_EVENT_FINAL) as! CreateEventFinalView
                vc.activityInfo = ApplicationManager.sharedInstance.activityList
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
    }
    
    
    @IBAction func cancelButtonPressed (sender: UIButton) {
        self.dismissViewController(isAnimated: true) { (didDismiss) in
            
        }
    }
    
    deinit {
        
    }
}

