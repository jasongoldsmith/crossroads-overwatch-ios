//
//  PushNotificationView.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/18/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit


protocol NotificationViewProtocol {
    func activeNotificationViewClosed ()
}

class PushNotificationView: UIView {
    
    let ACTION_MARGIN = CGFloat(120) //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
    let SCALE_STRENGTH = CGFloat(4) //%%% how quickly the card shrinks. Higher = slower shrinking
    let SCALE_MAX = CGFloat(0.93) //%%% upper bar for how much the card shrinks. Higher = shrinks less
    let ROTATION_MAX = CGFloat(1) //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
    let ROTATION_STRENGTH = CGFloat(320) //%%% strength of rotation. Higher = weaker rotation
    let ROTATION_ANGLE = CGFloat(M_PI/8) //%%% Higher = stronger rotation angle
    var originalPoint: CGPoint?
    var xFromCenter = CGFloat()
    var yFromCenter = CGFloat()
    
    
    @IBOutlet weak var eventStatusLabel: UILabel!
    @IBOutlet weak var eventStatusDescription: UILabel!
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var eventIconView: UIImageView!
    @IBOutlet weak var consoleName: UILabel!
    @IBOutlet weak var labelSecondHeightConstraint: NSLayoutConstraint!
    
    // Parents View Controller
    var delegate: NotificationViewProtocol?
    var pushInfo: ActiveStatePushInfo?
    var parentView: BaseViewController?
    var eventDescriptionFrame: CGRect?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowPath = UIBezierPath(rect: bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width:0.0, height:5.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
        
        //Add radius
        self.layer.cornerRadius = 2.0
    }
    
    
    
    @IBAction func openEventDetailViewController () {
        if let eventID = pushInfo?.eventID {
            self.parentView!.showEventDetailView(eventID: eventID)
            self.closeErrorView()
        }
    }
    
    func closeErrorView () {
        
        if let _ = ApplicationManager.sharedInstance.pushNotificationViewArray.last {
            ApplicationManager.sharedInstance.pushNotificationViewArray.removeLast()
        }
        
        self.parentView?.activeNotificationViewClosed()
        self.delegate?.activeNotificationViewClosed()
        
        self.delegate = nil
        self.pushInfo = nil
        self.parentView = nil
        self.eventDescriptionFrame = nil
        
        self.removeFromSuperview()
    }
    
    func closeErrorViewInBackground () {
        
        self.parentView?.activeNotificationViewClosed()
        self.delegate = nil
        self.pushInfo = nil
        self.parentView = nil
        self.eventDescriptionFrame = nil
        
        self.removeFromSuperview()
    }
    
    func addNotificationViewWithMessages (pushInfo: ActiveStatePushInfo, parentView: BaseViewController) -> PushNotificationView {
        
        self.pushInfo = pushInfo
        self.parentView = parentView
        
        if pushInfo.isMessageNotification == true {
            if let alertString = pushInfo.alertString {
                self.eventStatusLabel?.text = pushInfo.playerMessageConsoleName!
                self.consoleName.isHidden = true
                self.labelSecondHeightConstraint.constant = 0.0
                self.eventStatusDescription.text =  alertString
                let font = UIFont(name: "Helvetica", size: 14.0)
                let height = self.heightWithConstrainedWidth(width: (parentView.view.frame.width - 107), font: font!)
                self.updateFrameWithHeight(height: height + 10)
            }
        } else {
            if let eventName = pushInfo.eventName {
                self.consoleName.text = eventName.uppercased()
                let font = UIFont(name: "Helvetica", size: 14.0)
                let height = self.heightWithConstrainedWidth(width: (parentView.view.frame.width - 107), font: font!)
                self.updateFrameWithHeight(height: height + 10)
            }
            if let alertString = pushInfo.alertString {
                self.eventStatusDescription.text =  alertString
                let font = UIFont(name: "Helvetica", size: 14.0)
                let height = self.heightWithConstrainedWidth(width: (parentView.view.frame.width - 107), font: font!)
                self.updateFrameWithHeight(height: height + 10)
            }
            
            if let _ = pushInfo.eventClanName, let _ = pushInfo.eventconsole {
                self.eventStatusLabel.text = pushInfo.eventconsole! + ": " + pushInfo.eventClanName!
            } else {
                self.eventStatusLabel.isHidden = true
            }
        }
        
        if pushInfo.isMessageNotification == true {
            if let userHalmet = pushInfo.halmetImage,
                let imageUrl = URL(string:userHalmet){
                self.eventIconView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "iconAlert"))
                self.eventIconView.roundRectView()
            }
        } else {
            if let hasImage = pushInfo.imageURL,
                let imageUrl = URL(string:hasImage){
                self.eventIconView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "iconAlert"))
                self.eventIconView?.layer.borderColor = UIColor.white.cgColor
                self.eventIconView?.layer.borderWidth     = 1.0
                self.eventIconView?.layer.borderColor     = UIColor.white.cgColor
                self.eventIconView?.layer.masksToBounds   = true
            }
        }
        
        self.eventDescriptionFrame = self.eventStatusDescription.frame
        
        return self
    }
    
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.eventStatusDescription.text!.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func updateFrameWithHeight (height: CGFloat) {
        self.frame = CGRect(x:self.frame.origin.x + 9, y:self.frame.origin.y, width:self.frame.size.width - 18, height:
            self.eventStatusDescription.frame.origin.y + height)
    }
    
    //MARK:- Pan Gesture
    @IBAction func beginDragging (gestureRecognizer: UIPanGestureRecognizer) {
        
        self.xFromCenter = gestureRecognizer.translation(in: self).x
        self.yFromCenter = gestureRecognizer.translation(in: self).y
        
        switch gestureRecognizer.state {
        case .began:
            self.originalPoint = self.center
            break
        case .changed:
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
            
            //%%% degree change in radians
            let rotationAngel: CGFloat = 0.0
            
            //%%% amount the height changes when you move the card up to a certain point
            let scale = max(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPoint(x:self.originalPoint!.x + xFromCenter, y:
                self.originalPoint!.y + yFromCenter)
            
            //%%% rotate by certain amount
            let transform = CGAffineTransform(rotationAngle: rotationAngel)
            
            //%%% scale by certain amount
            let scaleTransform = transform.scaledBy(x: scale, y: scale)
            
            //%%% apply transformations
            self.transform = scaleTransform
            
            break
        case .ended:
            self.afterSwipeAction()
            break
        default:
            break
        }
    }
    
    func afterSwipeAction() {
        if (xFromCenter > ACTION_MARGIN) {
            rightAction()
        } else if (xFromCenter < -ACTION_MARGIN){
            leftAction()
        } else {
            animateCardBack()
            
        }
    }
    
    func rightAction() {
        animateCardToTheRight()
    }
    
    func animateCardToTheRight() {
        let rightEdge = CGFloat(500)
        animateCardOutTo(edge: rightEdge)
    }
    
    func leftAction() {
        animateCardToTheLeft()
    }
    
    func animateCardToTheLeft() {
        let leftEdge = CGFloat(-500)
        animateCardOutTo(edge: leftEdge)
    }
    
    func animateCardOutTo(edge: CGFloat) {
        let finishPoint = CGPoint(x:edge, y:2*yFromCenter + self.originalPoint!.y)
        UIView.animate(withDuration: 0.3, animations: {
            self.center = finishPoint;
        }, completion: {
            (value: Bool) in
            self.closeErrorView()
        })
    }
    
    func animateCardBack() {
        UIView.animate(withDuration: 0.3, animations: {
            self.center = self.originalPoint!;
            self.transform = CGAffineTransform(rotationAngle: 0);
        }
        )
    }
}
