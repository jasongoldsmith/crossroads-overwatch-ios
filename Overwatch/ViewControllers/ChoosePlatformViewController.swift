//
//  ChoosePlatformViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/25/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

class ChoosePlatformViewController: LoginBaseViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var battleTagView: UIView!
    @IBOutlet weak var consolesTable: UITableView!
    @IBOutlet weak var battleTagTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var battleNetButton: UIButton!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentConsoleLabel: UILabel!
    @IBOutlet weak var bottomAdviceLabel: UILabel!
    @IBOutlet weak var topAdviceLabel: UILabel!
    
    var consoles = ["PS4", "XBox One"]
    var currentConsole = "PC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consolesTable.register(UINib(nibName: "ConsoleCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    
    @IBAction func nextButtonPressed() {
        if let consoleId = battleTagTextField.text,
            consoleId != "" {
            let addConsoleRequest = AddConsoleRequest()
            addConsoleRequest.addConsoleWith(consoleType: currentConsole.lowercased().replacingOccurrences(of: " ", with: ""), and: consoleId, completion: { (value) -> () in
                if let wrappedValue = value,
                    wrappedValue == true {
                    print("Console added")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.validateCookies()
                    }
                } else {
                    print("Something went wrong registering consoles")
                }
            })
        }
    }
    
    @IBAction func battleNetButtonPressed() {
        self.view.endEditing(true)
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : WebViewViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW_SIGNIN) as! WebViewViewController
        vc.consoleLoginEndPoint = K.TRUrls.TR_BaseUrl + "/api/v1/auth/login"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func consoleButtonPressed() {
        if tableHeightConstraint.constant == 0 {
            tableHeightConstraint.constant = 90
        } else {
            tableHeightConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func refreshView() {
        currentConsoleLabel.text = currentConsole
        if currentConsole == "PC" {
            battleTagView.isHidden = true
            topAdviceLabel.isHidden = false
            battleNetButton.isHidden = false
            bottomAdviceLabel.isHidden = true
            nextButton.isHidden = true
            view.endEditing(true)
        } else {
            battleTagView.isHidden = false
            topAdviceLabel.isHidden = true
            battleNetButton.isHidden = true
            bottomAdviceLabel.isHidden = false
            nextButton.isHidden = false
            battleTagTextField.becomeFirstResponder()
        }
        bottomAdviceLabel.isHidden = !topAdviceLabel.isHidden
        nextButton.isHidden = !battleNetButton.isHidden
        consolesTable.reloadData()
        consoleButtonPressed()
    }
    
    func validateCookies() {
        let loginSucceed = !LoginHelper.sharedInstance.shouldShowLoginSceen()
        if !loginSucceed {
            UserInfo.removeUserData()
            ApplicationManager.sharedInstance.purgeSavedData()
            navBackButtonPressed(sender: nil)
        } else {
            dismissView()
        }
    }

    //Table View Data Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consoles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ConsoleCell
        cell.consoleTitle.text = consoles[indexPath.row]
        return cell
    }

    //Table View Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newConsole = consoles[indexPath.row]
        consoles.remove(at: indexPath.row)
        consoles.append(currentConsole)
        currentConsole = newConsole
        refreshView()
    }

    //UIGestureRecognizer Delegate methods
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: consolesTable))!{
            return false
        }
        return true
    }
}
