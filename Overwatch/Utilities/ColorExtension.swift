//
//  ColorExtension.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/13/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

extension UIColor {
    
    class func grayScaleColor(grayScale : CGFloat) -> UIColor {
        return UIColor(red: grayScale/255.0, green: grayScale/255.0, blue: grayScale/255.0, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor {
        return UIColor(red: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), green: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), blue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), alpha: CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
    }
    
    class func randomSolidColor() -> UIColor {
        return UIColor(red: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), green: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), blue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), alpha: 1.0)
    }
    
    class func randomColorWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), green: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), blue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), alpha: alpha)
    }
}
// Color palette for OverWatch

extension UIColor {
    class var lightBlueGrey: UIColor {
        return UIColor(red: 188.0 / 255.0, green: 197.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
    }
    
    class var metallicBlue: UIColor {
        return UIColor(red: 82.0 / 255.0, green: 100.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0)
    }
    
    class var marigold: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 195.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    class var greyblue: UIColor {
        return UIColor(red: 119.0 / 255.0, green: 142.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
    }
    
    class var orangeGoing: UIColor {
        return UIColor(red: 250.0 / 255.0, green: 113.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    class var brightSkyBlue: UIColor {
        return UIColor(red: 0.0, green: 194.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var tangerine: UIColor {
        return UIColor(red: 250.0 / 255.0, green: 148.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    class var darkGreyBlue: UIColor {
        return UIColor(red: 53.0 / 255.0, green: 65.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0)
    }
}

// Sample text styles

extension UIFont {
    class func headerFont() -> UIFont {
        return UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightRegular)
    }
}
