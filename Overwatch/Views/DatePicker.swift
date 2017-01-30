//
//  DatePicker.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

protocol DatePickerProtocol {
    func closeDatePicker()
}

class DatePicker: UIView {
    
    //Delegate
    var delegate: DatePickerProtocol?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.datePicker?.layer.cornerRadius = 5.0
        self.datePicker?.backgroundColor = UIColor.white
        self.datePicker?.layer.masksToBounds = true
        
        self.datePicker?.minimumDate = Date()
    }
    
    @IBAction func closePickerView (sender: UITapGestureRecognizer) {
        self.delegate?.closeDatePicker()
        self.delegate = nil
        self.removeFromSuperview()
    }
}
