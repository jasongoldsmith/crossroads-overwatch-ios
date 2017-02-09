//
//  BundleExtension.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/17/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
    class var applicationVersionNumber: String? {
        if let version = main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return nil
    }
    
    class var applicationBuildNumber: String? {
        if let build = main.infoDictionary?[kCFBundleVersionKey as String] as? String {
            return build
        }
        return nil
    }

}
