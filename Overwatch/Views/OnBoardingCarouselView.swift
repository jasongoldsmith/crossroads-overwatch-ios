//
//  OnBoardingCarouselView.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 3/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

protocol OnBoardingCarouselViewDelegate {
    func showNext()
}

class OnBoardingCarouselView: UIView {
    @IBOutlet weak var backgroundCardImage: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    //Delegate
    var delegate: OnBoardingCarouselViewDelegate?
    
    func setViewWith(_ data: OnBoardingCard) {
        if let backgroundURLString = data.backgroundURL,
            let backgroundURL = URL(string: backgroundURLString) {
            backgroundCardImage.sd_setImage(with: backgroundURL)
        }
        if let imageURLString = data.imageURL,
            let imageUrl = URL(string: imageURLString) {
            mainImage.sd_setImage(with: imageUrl)
        }
        if let logoURLString = data.logoAndTextURL,
            let imageUrl = URL(string: logoURLString) {
            logoImageView.sd_setImage(with: imageUrl)
        }
    }
    
    @IBAction func nextButtonPressed() {
        if let del = delegate {
            del.showNext()
        }
    }
}
