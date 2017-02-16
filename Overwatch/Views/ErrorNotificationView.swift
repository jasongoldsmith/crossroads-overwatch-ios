//
//  ErrorNotificationView.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/30/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit
import pop


class ErrorNotificationView: UIView {
    
    var errorSting: String? = nil
    @IBOutlet weak var errorMessage: UILabel!
    var errorTitle: String? = nil
    @IBOutlet weak var errorTitleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
    }
    
    @IBAction func closeErrorView (sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    func addErrorSubViewWithMessage () {
        self.errorMessage.text = ""
        self.errorTitleLabel.text = "ERROR"
        if self.superview != nil {
            return
        }
        
        if let message = errorSting {
            self.errorMessage.text = message
        }
        if let title = errorTitle {
            self.errorTitleLabel.text = title
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        window?.addSubview(self)
        
        let yAxisDistance:CGFloat = -self.frame.height
        let xAxiDistance:CGFloat  = 0
        self.frame = CGRect(x:xAxiDistance, y:yAxisDistance, width:window!.frame.width, height:self.frame.height)
        
        let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
        popAnimation.toValue = self.frame.height - 25
        self.layer.pop_add(popAnimation, forKey: "slideIn")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
            popAnimation.toValue = -self.frame.height
            popAnimation.completionBlock =  {(animation, finished) in
                self.removeFromSuperview()
            }
            self.layer.pop_add(popAnimation, forKey: "slideOut")
            
        }
    }
}


