//
//  OnBoardingErrorViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/30/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class OnBoardingErrorViewController: BaseViewController{
    
    var errorString = ""
    
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorLogoTypeImage: UIImageView!
    @IBOutlet weak var errorTypeLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    var emailEntered = ""
    var passwordEntered = ""
    var gamertagEntered = ""
    var platformEntered = ""
    var sourceCode = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        var offuscatedPassword = ""
        for _ in passwordEntered.characters {
            offuscatedPassword = offuscatedPassword + "●"
        }
        passwordEntered = offuscatedPassword

        guard let dictionary = ApplicationManager.sharedInstance.getDictionaryFromStringResponse(value: errorString),
            let details =  dictionary.object(forKey: "details") as? NSDictionary,
            let title =  details.object(forKey: "title") as? String,
            let code =  dictionary.object(forKey: "code") as? Int else {
                return
        }
        
        errorTitleLabel.text = title.uppercased()
        
        switch code {
        case 2:
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
            errorTypeLabel.text = emailEntered
            break
        case 3:
            errorLogoTypeImage.image = UIImage(named: "imgIconPassword")
            errorTypeLabel.text = passwordEntered
            break
        case 4:
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
            errorTypeLabel.text = emailEntered
            break
        case 5:
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
            errorTypeLabel.text = emailEntered
            break
        case 6:
            errorLogoTypeImage.image = UIImage(named: "imgIconPlatform")
            errorTypeLabel.text = platformEntered
            break
        case 7:
            errorLogoTypeImage.image = UIImage(named: "imgIconPlatform")
            errorTypeLabel.text = platformEntered
            break
        case 8:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            errorTypeLabel.text = gamertagEntered
            break
        case 9:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            errorTypeLabel.text = gamertagEntered
            break
        case 10:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            errorTypeLabel.text = gamertagEntered
            break
        case 11:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            errorTypeLabel.text = gamertagEntered
            break
        case 12:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            errorTypeLabel.text = gamertagEntered
            break
        case 13:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            errorTypeLabel.text = gamertagEntered
            break
        case 14:
            errorLogoTypeImage.image = UIImage(named: "imgIconPassword")
            errorTypeLabel.text = passwordEntered
            break
        case 15:
            errorLogoTypeImage.image = UIImage(named: "imgIconPassword")
            errorTypeLabel.text = passwordEntered
            break
        case 16:
            errorLogoTypeImage.image = UIImage(named: "imgIconPassword")
            errorTypeLabel.text = passwordEntered
            break
        case 17:
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
            errorTypeLabel.text = emailEntered
            break
        case 18:
            errorLogoTypeImage.image = UIImage(named: "imgIconPassword")
            errorTypeLabel.text = passwordEntered
            break
        default:
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
            errorTypeLabel.text = "<Text entered>"
            break
        }

        guard let message = details.object(forKey: "message") as? String else {
            return
        }
        errorDescriptionLabel.text = "\(message)"
    }
    
    @IBAction func backButtonPressed() {
        if let navController = navigationController {
            navController.popViewController(animated: true)
            navController.navigationBar.isHidden = true
        }
    }
    
    @IBAction func contactUsButtonPressed() {
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as!
        SendReportViewController
        vc.sourceCode = sourceCode
        if let dictionary = ApplicationManager.sharedInstance.getDictionaryFromStringResponse(value: errorString),
            let code =  dictionary.object(forKey: "code") as? Int {
            vc.errorCode = code
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        
    }
}
