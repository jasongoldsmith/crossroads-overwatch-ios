//
//  ActivityCheckPointPicker.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit


class ActivityCheckPointPicker: UIView {
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var buttonContainerView: UIView!
    @IBOutlet var doneButton: UIButton!
    
    override func layoutSubviews() {
        
        self.pickerView?.layer.cornerRadius = 5.0
        self.pickerView?.backgroundColor = UIColor.white
        self.pickerView?.layer.masksToBounds = true
        
        self.buttonContainerView?.layer.cornerRadius = 5.0
        self.buttonContainerView?.backgroundColor = UIColor.white
        self.buttonContainerView?.layer.masksToBounds = true
        
        // Setting it hidden
        self.buttonContainerView?.isHidden = true
    }
}

