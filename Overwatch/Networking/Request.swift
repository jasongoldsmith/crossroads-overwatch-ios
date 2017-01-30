//
//  Request.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let _sharedInstance = NetworkRequest()

typealias TRRequestClosure = (_ response: URLResponse, _ data: NSData, _ error: NSError) -> Void
typealias TRResponseCallBack = (_ error: String?, _ responseObject: JSON?) -> ()
typealias TRValueCallBack = (_ didSucceed: Bool?) -> ()
typealias TREventObjCallBack = (_ event: EventInfo?) -> ()
typealias TREventObjCallBackWithError = (_ error: String?, _ event: EventInfo?) -> ()

class NetworkRequest {

    //    MARK:  Singleton Method
    class var sharedInstance: NetworkRequest {
        return _sharedInstance
    }

    var mgr:SessionManager!
    var cookieStorage = HTTPCookieStorage.shared
    
    var shouldDrop = false
    var params:[String: AnyObject]?
    var URLMethod: HTTPMethod = .post
    var requestHandler: TRRequestClosure?
    var requestURL: String = ""
    var viewHandlesError: Bool = false
    
    // Activity Indicator
    var showActivityIndicator: Bool = true
    var showActivityIndicatorBgClear: Bool = false
    var activityIndicatorTopConstraint: CGFloat = 281.0
    
    init() {
        mgr = configureManager()
    }
    
    func headersForTrackingEvents() -> [String: String] {
        var devicePropertiesDictionary = [String:String]()
        devicePropertiesDictionary["x-type"] = "iOS"
//        devicePropertiesDictionary["x-os-version"] = ProcessInfo().operatingSystemVersionString
//        devicePropertiesDictionary["x-app-version"] = Bundle.printVersion()
//        devicePropertiesDictionary["x-manufacturer"] = "Apple"
//        devicePropertiesDictionary["x-model"] = UIDevice.currentDevice.modelName
        return devicePropertiesDictionary
    }
    

    func configureManager() -> Alamofire.SessionManager {
        let cfg = URLSessionConfiguration.default
        cfg.httpCookieStorage = cookieStorage
//        cfg.httpAdditionalHeaders = headersForTrackingEvents()
        cfg.timeoutIntervalForRequest = 12.0
        return Alamofire.SessionManager(configuration: cfg)
    }
    
    func resetManager() -> Alamofire.SessionManager {
        let cfg = URLSessionConfiguration.default
        cfg.httpCookieStorage = nil
        cfg.httpAdditionalHeaders = nil
        cfg.timeoutIntervalForRequest = 12.0
        return Alamofire.SessionManager(configuration: cfg)
    }
    
    func sendRequestWithCompletion (completion: @escaping TRResponseCallBack) {
        
        mgr.request(requestURL, method: URLMethod, parameters: params)
            .responseJSON { response in
                
                if let headerFields = response.response?.allHeaderFields as? [String: String],
                    let url = response.request?.url {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                    for cookie:HTTPCookie in cookies as [HTTPCookie] {
                        if cookie.domain == "travelerbackend.herokuapp.com" {
                            print("\(cookie)")
                        }
                    }
                }
                switch response.result {
                case .failure( _):
                    completion("Server request failed. Please wait a few seconds and refresh.", nil)
                    break
                case .success( _):
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar["responseType"].string == "ERR" {
                            if let message = swiftyJsonVar["error"].string {
                                completion(message, nil)
                                if self.viewHandlesError == false {
                                }
                            } else if let message = swiftyJsonVar["error"]["description"].string {
                                completion(message, nil)
                            } else if let statusCode = swiftyJsonVar["httpStatusCode"].int,
                                statusCode >= 400 {
                                print(swiftyJsonVar)
                                completion("Error http Status Code:\(statusCode)", nil)
                            } else {
                                completion("Error", nil)
                            }
                        } else if let statusCode = swiftyJsonVar["httpStatusCode"].int,
                            statusCode >= 400 {
                            print(swiftyJsonVar)
                            completion("Error http Status Code:\(statusCode)", nil)
                        } else {
                            completion(nil, swiftyJsonVar)
                        }
                    }
                }
        }
    }

    
//    func setCookies() {
//        let request = NSMutableURLRequest(URL: NSURL(string: "\(kBaseUrl)\(kInitCall)")!)
//        mgr.request(request).responseString {response in
//            guard let value = response.result.value,
//                let dictionary = self.getDictionaryFromStringResponse(value),
//                let uid =  dictionary.objectForKey("uid") as? String else { return }
//            UserSessionHelper.sharedInstance.setLoggedUser(uid)
//        }
//    }
//    
//    func removeCookies() {
//        guard let wrappedCookies = cookieStorage.cookies else {
//            return
//        }
//        for cookie in wrappedCookies {
//            cookieStorage.deleteCookie(cookie)
//        }
//        resetManager()
//    }
//    
}
