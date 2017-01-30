//
//  CustomError.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CustomErrorDelegate {
    @objc optional func okButtonPressed ()
    @objc optional func customErrorActionButtonPressed ()
    @objc optional func customErrorActionButtonPressedWithSelector(selector: Selector)
}


class CustomError: UIView {
    
    var delegate: CustomErrorDelegate?
    var selector: Selector?
    
    @IBOutlet weak var errorViewContainer: UIView!
    @IBOutlet weak var errorMessageHeader: UILabel!
    @IBOutlet weak var errorMessageDescription: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        self.actionButton?.layer.cornerRadius = 2.0
        self.errorViewContainer?.layer.cornerRadius = 2.0
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
    }
    
    
    @IBAction func cancelView () {
        self.removeView()
    }
    
    @IBAction func closeView () {
        self.delegate?.okButtonPressed!()
        self.removeView()
    }
    
    @IBAction func actionButtonPressed () {
        
        if let _ = self.selector {
            self.delegate?.customErrorActionButtonPressedWithSelector!(selector: self.selector!)
        } else {
            self.delegate?.customErrorActionButtonPressed!()
        }
        
        self.removeView()
    }
    
    func removeView () {
        if let _ = self.delegate {
            self.delegate = nil
        }
        
        self.removeFromSuperview()
    }
}
