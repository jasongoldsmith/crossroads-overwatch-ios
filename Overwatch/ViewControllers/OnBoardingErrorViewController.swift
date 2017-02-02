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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let dictionary = self.getDictionaryFromStringResponse(value: errorString),
            let type =  dictionary.object(forKey: "type") as? String,
            let details =  dictionary.object(forKey: "details") as? NSDictionary,
            let title =  details.object(forKey: "title") as? String,
            let code =  dictionary.object(forKey: "code") as? Int else {
                return
        }
        
        errorTitleLabel.text = type.uppercased()
        errorTypeLabel.text = "<\(type)>"
        errorDescriptionLabel.text = "\(title)."
        
        switch code {
        case 2:
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
            break
        case 3:
            errorLogoTypeImage.image = UIImage(named: "imgIconPassword")
            break
        case 4:
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
            break
        case 5:
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
            break
        case 6:
            errorLogoTypeImage.image = UIImage(named: "imgIconPlatform")
            break
        case 7:
            errorLogoTypeImage.image = UIImage(named: "imgIconPlatform")
            break
        case 8:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            break
        case 9:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            break
        case 10:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            break
        case 11:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            break
        case 12:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            break
        case 13:
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
            break
        case 14:
            errorLogoTypeImage.image = UIImage(named: "imgIconPassword")
            break
        case 15:
            errorLogoTypeImage.image = UIImage(named: "imgIconPassword")
            break
        default:
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
            break
        }

        guard let message = details.object(forKey: "") as? String else {
            return
        }
        errorDescriptionLabel.text = "\(title). \(message)"
    }
    
    private func getDictionaryFromStringResponse(value:String) -> NSDictionary? {
        if let data = value.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let dic = json as? NSDictionary {
                    return dic
                }
            } catch _ {
                return nil
            }
        }
        return nil
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        
    }
}
