//
//  StringExtension.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/20/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

extension String {
    
    var isPlayStationVerified: Bool {
        return range(of: "^[a-zA-Z0-9-_]+$", options: .regularExpression) != nil
    }
    
    var isXboxVerified: Bool {
        return range(of: "^[A-Za-z][A-Za-z0-9]++(?: [a-zA-Z0-9]++)?$", options: .regularExpression) != nil
    }

    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: self) {
            return true
        }
        return false
    }

    var isValidPassword: Bool {
        if self.characters.count >= 4 {
            return true
        }
//        let passwordRegEx = "((?=.*\\d)(?=.*[a-z]).{5,50})" // https://www.mkyong.com/regular-expressions/how-to-validate-password-with-regular-expression/
//        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
//        if passwordTest.evaluate(with: self) {
//            return true
//        }
        return false
    }

    var isValidXBoxBattleTag: Bool {
        if self.characters.count >= 1 && self.characters.count <= 15{
            let xBoxRegEx = "[A-Za-z]{2,}"
            let xBoxTest = NSPredicate(format:"SELF MATCHES %@", xBoxRegEx)
            if xBoxTest.evaluate(with: self) {
                return true
            }
        }
        return false
    }

    var isValidPSNBattleTag: Bool {
        if self.characters.count >= 3 && self.characters.count <= 16{
            let playStationRegEx = "^[a-zA-Z0-9-_]+$"
            let playStationTest = NSPredicate(format:"SELF MATCHES %@", playStationRegEx)
            if playStationTest.evaluate(with: self) {
                return true
            }
        }
        return false
    }
}
