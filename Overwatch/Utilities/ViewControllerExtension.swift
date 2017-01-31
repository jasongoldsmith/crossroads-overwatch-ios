//
//  ViewControllerExtension.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/17/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    typealias ActivityIndicatorCompletion = (_ complete: Bool?) -> ()
    typealias ActivityIndicatorCompletionWithHandler = (_ action: UIAlertAction?) -> ()
    typealias ActivityIndicatorWithButtonIndex = (_ complete: String?) -> ()
    
    //let alertIndex = alertView.actions.indexOf(action)
    
    func displayAlertWithActionHandler(title: String, message: String, buttonOneTitle: String?, buttonTwoTitle: String?, buttonThreeTitle: String, completionHandler: @escaping ActivityIndicatorWithButtonIndex) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closure = { (index: String) in
            { (action: UIAlertAction!) -> Void in
                completionHandler(index)
            }
        }
        
        if let _ = buttonOneTitle {
            alertView.addAction(UIAlertAction(title: buttonOneTitle, style: .default, handler: closure(K.Legal.PP)))
        }
        if let _ = buttonTwoTitle {
            alertView.addAction(UIAlertAction(title: buttonTwoTitle, style: .default, handler: closure(K.Legal.TOS)))
        }
        
        alertView.addAction(UIAlertAction(title: buttonThreeTitle, style: .cancel, handler: closure(K.Legal.OK)))
        present(alertView, animated: true, completion: nil)
    }
    
    func displayAlertWithTitle(title: String, complete: @escaping ActivityIndicatorCompletion) {
        let alertView = UIAlertController(title: title, message: " ", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                complete(true)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        present(alertView, animated: true, completion: nil)
    }
    
    func displayAlertWithTitleAndMessageAnOK(title: String, message: String, complete: @escaping ActivityIndicatorCompletion) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                complete(
                    true)
                
            case .cancel:
                print("OK")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        present(alertView, animated: true, completion: nil)
    }

    func displayAlertWithTwoButtonsTitleAndMessage(title: String, message: String?, buttonOne: String, buttonTwo: String, complete: @escaping
        ActivityIndicatorCompletion) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: buttonOne, style: .cancel, handler: { action in
            complete(true)
        }))
        
        alertView.addAction(UIAlertAction(title: buttonTwo, style: .default, handler: { action in
            complete(false)
        }))
        
        present(alertView, animated: true, completion: nil)
    }
    
    

    func displayAlertWithTitleAndMessage(title: String, message: String, complete: @escaping ActivityIndicatorCompletion) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                complete(true)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        alertView.addAction(UIAlertAction(title: "Upgrade", style: .default, handler: { action in
            switch action.style{
            case .default:
                complete(
                    true)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        present(alertView, animated: true, completion: nil)
    }
    
    func addNavigationBarButtons (showBack: Bool, showCancel: Bool) {
        
        //Navigation Bar Title Font
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 17)!]
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(2.0, for: .default)
        
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        nav?.barTintColor = UIColor(red: 28/255, green: 43/255, blue: 51/255, alpha: 1)
        
        if showBack {
            //Adding Back Button to nav Bar
            let rect = CGRect(x:0,y:0,width:44,height:44)
            let leftButton = UIButton(frame: rect)
            leftButton.setImage(UIImage(named: "iconBackArrow"), for: .normal)
            leftButton.addTarget(self, action: #selector(BaseViewController.navBackButtonPressed), for: .touchUpInside)
            leftButton.transform = CGAffineTransform(translationX: -10, y: 0)
            
            // Add the button to a container, otherwise the transform will be ignored
            let leftButtonContainer = UIView(frame: leftButton.frame)
            leftButtonContainer.addSubview(leftButton)
            
            let leftBarButton = UIBarButtonItem()
            leftBarButton.customView = leftButtonContainer
            
            self.navigationItem.leftBarButtonItem = leftBarButton
        }
        
        if showCancel {
            //Adding Back Button to nav Bar
            let rect = CGRect(x:0,y:0,width:60,height:17)
            let rightButton = UIButton(frame: rect)
            rightButton.setTitle("Cancel", for: .normal)
            rightButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
            rightButton.addTarget(self, action: #selector(BaseViewController.navigationButtonClosePressed), for: .touchUpInside)
            rightButton.transform = CGAffineTransform(translationX: 3, y: 0)
            
            // Add the button to a container, otherwise the transform will be ignored
            let rightButtonContainer = UIView(frame: rightButton.frame)
            rightButtonContainer.addSubview(rightButton)
            
            let rightBarButton = UIBarButtonItem()
            rightBarButton.customView = rightButtonContainer
            
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    func hideNavigationBar () {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showNavigationbar () {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
