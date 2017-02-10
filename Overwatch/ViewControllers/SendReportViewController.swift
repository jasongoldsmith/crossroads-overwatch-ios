//
//  SendReportViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 2/1/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class SendReportViewController: LoginBaseViewController, UITextViewDelegate, CustomErrorDelegate {
    
    @IBOutlet weak var bodyTextView: UITextView!
    let placeHolderString = "What would you like to tell us?"

    var eventID: String?
    var commentID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentEmail = ApplicationManager.sharedInstance.currentUser?.email {
            emailTextField.text = currentEmail
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = ApplicationManager.sharedInstance.currentUser?.email {
            bodyTextView.becomeFirstResponder()
        } else {
            emailTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func sendButtonPressed() {
        if let body = bodyTextView.text,
            body != "",
            body != placeHolderString {
            view.endEditing(true)
            if let wrappedEventId = eventID,
                let wrappedCommentId = commentID,
                let email = emailTextField.text,
                email.isValidEmail {
                let reportRequest = ReportComment()
                reportRequest.reportAComment(commentID: wrappedCommentId, eventID: wrappedEventId, reportDetail: body, reportedEmail: email, completion: { (didSucceed) in
                    if let succeed = didSucceed,
                        succeed {
                        let errorView = Bundle.main.loadNibNamed("CustomError", owner: self, options: nil)?[0] as! CustomError
                        errorView.errorMessageHeader?.text = "REPORT SUBMITTED"
                        errorView.errorMessageDescription?.text = "We are on the case and will work to address your issue as soon as possible."
                        errorView.frame = self.view.frame
                        errorView.delegate = self
                        
                        self.view.addSubview(errorView)
                    }
                })
            } else {
                let reportRequest = CreateAReportRequest()
                reportRequest.sendCreatedReport(description: body, completion: { (didSucceed) in
                    self.view.endEditing(true)
                    if (didSucceed == true)  {
                        
                        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CONTACT_MESSAGE_SENT) as! MessageSentConfViewController
                        if let navController = self.navigationController {
                            navController.pushViewController(vc, animated: true)
                        } else {
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                })
            }
        }
    }
    
    //TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderString {
            textView.text = ""
        }
    }
    
    //CustomErrorDelegate method
    func okButtonPressed () {
        self.dismissViewController(isAnimated: true) { (didDismiss) in
            
        }
    }
}
