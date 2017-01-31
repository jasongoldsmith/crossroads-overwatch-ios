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
        if errorString == "Email is already taken" {
            errorTitleLabel.text = "ALREADY TAKEN"
            errorTypeLabel.text = "<Email entered>"
            errorDescriptionLabel.text = "An account already exists for that <email>. Please check for any typos."
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
        } else if errorString == "Battletag/Gamertag is already taken" {
            errorTitleLabel.text = "ALREADY TAKEN"
            errorTypeLabel.text = "<Gamertag entered>"
            errorDescriptionLabel.text = "An account already exists for that <Battletag/Gamertag>. Please check for any typos."
            errorLogoTypeImage.image = UIImage(named: "imgIconID")
        } else if errorString == "Invalid Password Provided" {
            errorTitleLabel.text = "INVALID"
            errorTypeLabel.text = "<Password entered>"
            errorDescriptionLabel.text = "Invalid <Password> for this account. Please check for any typos."
            errorLogoTypeImage.image = UIImage(named: "imgIconPassword")
        } else if errorString == "No User found with the email provided" {
            errorTitleLabel.text = "CAN’T FIND PLAYER"
            errorTypeLabel.text = "<Email entered>"
            errorDescriptionLabel.text = "We couldn’t find that <email>. Please check for any typos."
            errorLogoTypeImage.image = UIImage(named: "imgIconEmail")
        }
    }

    @IBAction func backButtonPressed() {
        if let navController = navigationController {
            navController.popViewController(animated: true)
            navController.navigationBar.isHidden = true
        }
    }

    deinit {
        
    }
}
