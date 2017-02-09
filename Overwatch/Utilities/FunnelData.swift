//
//  FunnelData.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import CoreTelephony
import Mixpanel

class FunnelData {
    
    //CoreTelephony data
    static let telephonyInfo = CTTelephonyNetworkInfo()

    class func getData () -> [String: AnyObject] {
        var devicePropertiesDictionary = [String:AnyObject]()
        let branchSDKVersion = "0.12.6"
        let fireBaseSDKVersion = "3.5.2"
        let fabricSDK = "1.6.8"
        let size = UIScreen.main.bounds.size
        let infoDict = Bundle.main.infoDictionary
        if let infoDict = infoDict {
            devicePropertiesDictionary["$app_build_number"]     = infoDict["CFBundleVersion"] as AnyObject?
            devicePropertiesDictionary["$app_version_string"]   = infoDict["CFBundleShortVersionString"] as AnyObject?
        }
        devicePropertiesDictionary["$carrier"]           = telephonyInfo.subscriberCellularProvider?.carrierName as AnyObject?
        devicePropertiesDictionary["mp_lib"]             = "iphone" as AnyObject?
        devicePropertiesDictionary["$lib_version"]       = self.libVersion() as AnyObject?
        devicePropertiesDictionary["$manufacturer"]      = "Apple" as AnyObject?
        devicePropertiesDictionary["$os"]                = UIDevice.current.systemName as AnyObject?
        devicePropertiesDictionary["$os_version"]        = UIDevice.current.systemVersion as AnyObject?
        devicePropertiesDictionary["$model"]             = UIDevice.current.modelName as AnyObject?
        devicePropertiesDictionary["$screen_height"]     = Int(size.height) as AnyObject?
        devicePropertiesDictionary["$screen_width"]      = Int(size.width) as AnyObject?
        devicePropertiesDictionary["$ios_device_model"]  = UIDevice.current.modelName as AnyObject?
        devicePropertiesDictionary["$ios_version"]       = UIDevice.current.systemVersion as AnyObject?
        devicePropertiesDictionary["$ios_lib_version"]   = self.libVersion() as AnyObject?
        devicePropertiesDictionary["x-fbasesdk"] = fireBaseSDKVersion as AnyObject?
        devicePropertiesDictionary["x-branchsdk"] = branchSDKVersion as AnyObject?
        devicePropertiesDictionary["x-fabricsdk"] = fabricSDK as AnyObject?
        devicePropertiesDictionary["x-newloginflow"] = true as AnyObject?
        #if RELEASE
            devicePropertiesDictionary["config_token"] = "003c2fff-9d24-4dbe-be76-6ab21574e2d9" as AnyObject?
        #elseif ADHOC
            devicePropertiesDictionary["config_token"] = "123" as AnyObject?
        #else
            devicePropertiesDictionary["config_token"] = "123" as AnyObject?
//            devicePropertiesDictionary["config_token"] = "003c2fff-9d24-4dbe-be76-6ab21574e2d9" as AnyObject?
        #endif
        
        if let token = ApplicationManager.sharedInstance.appConfiguration?.mixPanelToken {
            let mixpanel = Mixpanel.sharedInstance(withToken: token)
            devicePropertiesDictionary["x-mixpanelid"] = mixpanel.distinctId as AnyObject?
        }
        return devicePropertiesDictionary
    }

    class func libVersion() -> String {
        return "3.0.2"
    }
    
    class func getCurrentRadio() -> String? {
        var radio = telephonyInfo.currentRadioAccessTechnology
        let prefix = "CTRadioAccessTechnology"
        if radio == nil {
            radio = "None"
        } else if radio!.hasPrefix(prefix) {
            radio = (radio! as NSString).substring(from: prefix.characters.count)
        }
        return radio
    }
}
