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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var battleTagView: UIView!
    @IBOutlet weak var consolesTable: UITableView!
    @IBOutlet weak var battleTagTextField: UITextField!
    @IBOutlet weak var battleNetButton: UIButton!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentConsoleLabel: UILabel!
    @IBOutlet weak var bottomAdviceLabel: UILabel!
    @IBOutlet weak var topAdviceLabel: UILabel!
    
    var consoles = ["PlayStation 4", "Xbox One"]
    var currentConsole = "PC"
    var comingFromProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consolesTable.register(UINib(nibName: "ConsoleCell", bundle: nil), forCellReuseIdentifier: "Cell")
        if comingFromProfile {
            handleComingFromProfile()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    
    @IBAction func nextButtonPressed() {
        guard let consoleId = battleTagTextField.text,
            isValidBattleTag(battleTag: consoleId) else {
                ApplicationManager.sharedInstance.addErrorSubViewWithMessage(errorString: "Please enter a valid Gamertag")
                return
        }
        if let consoleType = ApplicationManager.sharedInstance.getConsoleTypeFrom(consoleString: currentConsole){
            let addConsoleRequest = AddConsoleRequest()
            addConsoleRequest.addConsoleWith(consoleType: consoleType, and: consoleId, completion: { (error, responseObject) -> () in
                if let _ = responseObject {
                    print("Console added")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.validateCookies()
                    }
                } else if let wrappedError = error {
                    let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "onBoardingErrorViewController") as! OnBoardingErrorViewController
                    vc.errorString = wrappedError
                    if let platformName = ApplicationManager.sharedInstance.getConsoleNameFrom(consoleType: consoleType) {
                        vc.platformEntered = platformName
                    }
                    vc.gamertagEntered = consoleId
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.view.endEditing(true)
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
        vc.consoleLoginEndPoint = K.TRUrls.TR_BaseUrl + "/api/v1/a/user/addConsole?consoleType=pc"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func consoleButtonPressed() {
        if consoles.count > 0 {
            if tableHeightConstraint.constant == 0 {
                if consoles.count > 1 {
                    tableHeightConstraint.constant = 90
                } else {
                    tableHeightConstraint.constant = 47
                }
            } else {
                tableHeightConstraint.constant = 0
            }
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func handleComingFromProfile() {
        titleLabel.text = "ADD LINKED ACCOUNT"
        nextButton.setTitle("LINK TO CROSSROADS", for: .normal)
        bottomAdviceLabel.isHidden = true
        topAdviceLabel.isHidden = true
        consoles.removeAll()
        let possibleConsoles = ["PC", "PlayStation 4", "Xbox One"]
        guard let savedConsoles = ApplicationManager.sharedInstance.currentUser?.consoles else {
            return
        }
        var userConsoles = [String]()
        for console in savedConsoles {
            guard let consoleType = console.consoleType?.uppercased(),
            let consoleName = ApplicationManager.sharedInstance.getConsoleNameFrom(consoleType: consoleType) else {
                break
            }
            userConsoles.append(consoleName)
        }
        
        
        //
        var elementFound = false
        for possibleConsole in  possibleConsoles {
            for console in userConsoles {
                if possibleConsole == console {
                    elementFound = true
                    break
                }
            }
            if !elementFound {
                consoles.append(possibleConsole)
            }
            elementFound = false
        }
        if let _ = consoles.first {
            currentConsole = consoles.removeFirst()
        }
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
        if comingFromProfile {
            titleLabel.text = "ADD LINKED ACCOUNT"
            nextButton.setTitle("LINK TO CROSSROADS", for: .normal)
            bottomAdviceLabel.isHidden = true
            topAdviceLabel.isHidden = true
        }
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
    
    //Validate data
    override func areTheFieldsValid() -> Bool {
        if let battleTag = battleTagTextField.text,
            isValidBattleTag(battleTag: battleTag) {
            return true
        }
        return false
    }
    
    //UITextFieldDelegate Delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if areTheFieldsValid() {
            nextButtonPressed()
        }
        return true
    }
    
    //Checking Battle Tag
    func isValidBattleTag(battleTag:String) -> Bool {
        if let consoleType = ApplicationManager.sharedInstance.getConsoleTypeFrom(consoleString: currentConsole){
            if consoleType == "ps4" {
                return battleTag.isValidPSNBattleTag
            } else if consoleType == "xboxone" {
                return battleTag.isValidXBoxBattleTag
            }
        }
        return false
    }
}
