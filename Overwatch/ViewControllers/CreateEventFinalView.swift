//
//  CreateEventFinalView.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/19/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift
import SDWebImage

class CreateEventFinalView: BaseViewController, DatePickerProtocol, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var activityBGImageView: UIImageView!
    @IBOutlet weak var activityIconView: UIImageView!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityLevelLabel: UILabel!
    @IBOutlet weak var checkPointDropDownTriangle: UIImageView!
    @IBOutlet weak var tagDropDownTriangle: UIImageView!
    
    // SubViews
    @IBOutlet weak var activitNameView: UIView!
    @IBOutlet weak var activitCheckPointView: UIView!
    @IBOutlet weak var activitStartTimeView: UIView!
    @IBOutlet weak var activitDetailsView: UIView!
    @IBOutlet weak var activityNameViewsIcon: UIImageView!
    
    // View Button
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activityNameButton: UIButton!
    @IBOutlet weak var activityCheckPointButton: UIButton!
    @IBOutlet weak var activityStartTimeButton: UIButton!
    @IBOutlet weak var activityDetailButton: UIButton!
    @IBOutlet weak var addActivityButton: UIButton!
    
    //Activities of same sub-typeJ
    var selectedActivity: ActivityInfo?
    lazy var activityInfo: [ActivityInfo] = []
    
    // Contains Unique Activities Based on SubType/ Difficulty
    var filteredActivitiesOfSubTypeAndDifficulty: [ActivityInfo] = []
    
    // Contains Unique Activities Based on SubType/ Difficulty
    var filteredCheckPoints: [ActivityInfo] = []
    
    // Filtered Tags
    var filteredTags: [ActivityInfo] = []
    
    var showGropName: Bool = false
    var showCheckPoint: Bool = false
    var showDetail: Bool = false
    
    //Table View
    @IBOutlet weak var dropDownTableView: UITableView!
    var dataArray: [ActivityInfo] = []
    
    //Date Picker
    var datePickerView: DatePicker?
    
    var keys:[String] = []
    @IBOutlet weak var searchScrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.addModifiersView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Hide Navigation
        self.hideNavigationBar()
        
        // Adding Corner Radius to Views
        self.activitNameView.layer.cornerRadius = 2.0
        self.activitDetailsView.layer.cornerRadius = 2.0
        self.activitStartTimeView.layer.cornerRadius = 2.0
        self.activitCheckPointView.layer.cornerRadius = 2.0
        
        
        //Add Date Picker
        self.datePickerView = Bundle.main.loadNibNamed("DatePicker", owner: self, options: nil)?[0] as? DatePicker
        self.datePickerView?.frame = self.view.bounds
        self.datePickerView?.delegate = self
        
        
        //Filtered Arrays
        self.filteredActivitiesOfSubTypeAndDifficulty = self.getFiletreObjOfSubTypeAndDifficulty()!
        
        //DropDownTable
        self.dropDownTableView.isHidden = true
        self.dropDownTableView.layer.borderWidth = 3.0
        self.dropDownTableView.layer.cornerRadius = 2.0
        self.dropDownTableView.layer.borderColor = UIColor(red: 3/255, green: 81/255, blue: 102/255, alpha: 1).cgColor
        
        self.activityDetailButton.setTitle("Details (Optional)", for: .normal)
        
        // Update View
        if let _ = self.selectedActivity {
            self.updateViewWithActivity(activityInfo: self.selectedActivity!)
        } else {
            if let _ = self.filteredActivitiesOfSubTypeAndDifficulty.first {
                self.updateViewWithActivity(activityInfo: self.filteredActivitiesOfSubTypeAndDifficulty.first!)
            }
        }
    }
    
    //MARK: - Refresh View
    func updateViewWithActivity (activityInfo: ActivityInfo) {
        
        //Set Selected Activity
        self.selectedActivity = activityInfo
        
        // Update View
        if let activitySubType = activityInfo.activitySubType {
            self.activityNameLabel.text = activitySubType.uppercased()
        }
        
        if let level = activityInfo.activityLevel, level != "0" {
            let activityLavelString: String = "LEVEL \(level) "
            let stringFontAttribute = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 12)!]
            let levelAttributedStr = NSAttributedString(string: activityLavelString, attributes: stringFontAttribute)
            let finalString: NSMutableAttributedString = levelAttributedStr.mutableCopy() as! NSMutableAttributedString
            
            if let activityLight = activityInfo.activityLight, Int(activityLight) > 0 {
                let activityAttrString = NSMutableAttributedString(string: "Recommended Light: ")
                let activityColorString = NSMutableAttributedString(string: "\u{02726}\(activityLight)")
                activityColorString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1) , range: NSMakeRange(0, activityColorString.length))
                
                activityAttrString.append(activityColorString)
                finalString.append(activityAttrString)
            } else {
                if let location = activityInfo.activitylocation?.aSubLocation, location != "" {
                    let locationString = NSAttributedString(string: location, attributes: stringFontAttribute)
                    finalString.append(locationString)
                }
                
            }
            
            self.activityLevelLabel.attributedText = finalString
        } else {
            if let _ = activityInfo.activityDescription {
                self.activityLevelLabel.text = activityInfo.activityDescription!
            }
        }
        
        if let activityIconImage = activityInfo.activityIconImage,
            let imageUrl = URL(string: activityIconImage) {
            self.activityIconView.sd_setImage(with: imageUrl)
        }
        
        let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
            self.activityBGImageView.alpha = 0
            self.activityBGImageView.image = image
            UIView.animate(withDuration: 0.5, animations: {
                self.activityBGImageView.alpha = 1
            })
        }

        if let activityImage = activityInfo.activityImage,
            activityImage != "",
            let imageURL = URL(string: activityImage) {
            activityBGImageView.sd_setImage(with: imageURL, completed: block)
        }
        
        if let aType = activityInfo.activityType {
            var nameString = aType
            
            if let aSubType =  activityInfo.activitySubType, aSubType != "" {
                nameString = "\(nameString) - \(aSubType)"
            }
            if let aDifficulty = activityInfo.activityDificulty, aDifficulty != "" {
                nameString = "\(nameString) - \(aDifficulty)"
            }
            
            self.activityNameButton.setTitle(nameString, for: .normal)
        }
        
        if let aCheckPoint = activityInfo.activityCheckPoint, aCheckPoint != "" {
            self.activityCheckPointButton.setTitle(aCheckPoint, for: .normal)
        }
        
        self.filteredTags = self.getActivitiesFilteredSubDifficultyCheckPoint(activity: self.selectedActivity!)!
        if let fTags = self.getActivitiesFilteredSubDifficultyCheckPoint(activity: self.selectedActivity!), fTags.count > 1 {
            self.tagDropDownTriangle.isHidden = false
        } else {
            self.tagDropDownTriangle.isHidden = true
        }
        
        if let description = activityInfo.activityTag, description != "" {
            self.activityDetailButton.setTitle(description, for: .normal)
        } else {
            self.activityDetailButton.setTitle("Details (Optional)", for: .normal)
        }
        
        //ModifierView
        self.addModifiersView()
        self.view.bringSubview(toFront: self.dropDownTableView)
        
        //Show hide CheckPoint dropdown triangle
        let checkPoint = ApplicationManager.sharedInstance.getActivitiesMatchingSubTypeAndLevel(activity: self.selectedActivity!)
        if let _ = checkPoint, (checkPoint?.count)! > 1 {
            self.checkPointDropDownTriangle.isHidden = false
        } else {
            self.checkPointDropDownTriangle.isHidden = true
        }
    }
    
    //MARK: - Protocol Methods
    func closeDatePicker() {
        if let selectedTime = self.datePickerView?.datePicker.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d 'at' h:mm a"
            dateFormatter.locale = Locale.init(identifier: "en_GB")
            self.activityStartTimeButton?.setTitle("Start Time - " + dateFormatter.string(from: selectedTime), for: .normal)
        } else {
            self.activityStartTimeButton?.setTitle("Start Time - Now", for: .normal)
        }
    }
    
    //MARK: - Button Actions
    @IBAction func showDatePicker (sender: UIButton) {
        if self.dropDownTableView?.isHidden == false {
            closeDropDown ()
        }
        guard let _ = self.datePickerView else {
            return
        }


        self.datePickerView?.alpha = 0
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.datePickerView?.alpha = 1
        }
        
        self.datePickerView?.delegate = self
        self.view.addSubview(self.datePickerView!)
    }
    
    @IBAction func showActivityName (sender: UIButton) {
        
        self.dataArray.removeAll()
        if self.dropDownTableView?.isHidden == false {
            closeDropDown ()
            self.showGropName = false
            return
        }
        if self.filteredActivitiesOfSubTypeAndDifficulty.count <= 1 {
            return
        }
        

        self.showGropName = true
        self.dataArray = self.filteredActivitiesOfSubTypeAndDifficulty.sorted{$0.activitySubType! < $1.activitySubType!}
        let itemToDelete = self.dataArray.filter{$0.activityDificulty == self.selectedActivity?.activityDificulty && $0.activitySubType == self.selectedActivity?.activitySubType}.first
        if let _ = itemToDelete {
            let index = self.dataArray.index(of: itemToDelete!)
            self.dataArray.remove(at: index!)
        }
        
        self.dropDownTableView?.isHidden = false
        self.dropDownTableView?.reloadData()
        self.updateTableViewFrame(sender: self.activitNameView)
    }
    
    
    @IBAction func showCheckPoints (sender: UIButton) {
        if self.dropDownTableView?.isHidden == false {
            closeDropDown ()
            self.showCheckPoint = false
            return
        }
        self.dataArray.removeAll()
        
        if let selActivity = self.selectedActivity {
            self.filteredCheckPoints = ApplicationManager.sharedInstance.getActivitiesMatchingSubTypeAndLevel(activity: selActivity)!
        }
        
        if self.filteredCheckPoints.count <= 1 {
            return
        }
                
        self.showCheckPoint = true
        self.dataArray = self.filteredCheckPoints.sorted{$0.activityCheckPoint! < $1.activityCheckPoint!}
        
        let itemToDelete = self.dataArray.filter{$0.activityCheckPoint == self.selectedActivity?.activityCheckPoint}.first
        if let _ = itemToDelete {
            let index = self.dataArray.index(of: itemToDelete!)
            self.dataArray.remove(at: index!)
        }
        
        
        self.dropDownTableView?.isHidden = false
        self.dropDownTableView?.reloadData()
        self.updateTableViewFrame(sender: self.activitCheckPointView)
    }
    
    @IBAction func showDetail (sender: UIButton) {
        self.dataArray.removeAll()
        if let selActivity = self.selectedActivity {
            self.filteredTags = self.getActivitiesFilteredSubDifficultyCheckPoint(activity: selActivity)!
        }

        
        if self.filteredTags.count <= 1 {
            return
        }
        
        if self.dropDownTableView?.isHidden == false {
            self.dropDownTableView?.isHidden = true
            self.showDetail = false
            
            return
        }
        
        self.showDetail = true
        self.dataArray = self.filteredTags.sorted{$0.activityTag! < $1.activityTag!}
        
        //        let itemToDelete = self.dataArray.filter{$0.activitySubType == self.selectedActivity?.activitySubType && $0.activityDificulty == self.selectedActivity?.activityDificulty && $0.activityCheckPoint == self.selectedActivity?.activityCheckPoint}.first
        //        if let _ = itemToDelete {
        //            let index = self.dataArray.indexOf(itemToDelete!)
        //            self.dataArray.removeAtIndex(index!)
        //        }
        
        self.dropDownTableView?.isHidden = false
        self.dropDownTableView?.reloadData()
        self.updateTableViewFrame(sender: self.activitDetailsView)
    }
    
    @IBAction func addActivityButtonClicked (sender: UIButton) {
        guard let _ = self.selectedActivity else {
            return
        }
        let createEventRequest = CreateEventRequest()
        createEventRequest.createAnEventWithActivity(activity: self.selectedActivity!, selectedTime: self.datePickerView?.datePicker.date as NSDate?, completion: {(event) -> () in
            self.datePickerView?.delegate = nil
            
            if let eventInfo = event {
                
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : EventDetailViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_EVENT_DESCRIPTION) as! EventDetailViewController
                vc.eventInfo = eventInfo
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                ApplicationManager.sharedInstance.log.debug("Create Event Failed")
            }
        })

    }
    
    @IBAction func cancelButtonPressed (sender: UIButton) {
        self.datePickerView?.delegate = nil
        self.dismissViewController(isAnimated: true) { (didDismiss) in
            
        }
    }
    
    @IBAction func backButtonPressed (sender: UIButton) {
        self.datePickerView?.delegate = nil
        if let navController = navigationController {
            navController.popToRootViewController(animated: true)
        }
    }
    
    
    func getFiletreObjOfSubTypeAndDifficulty () -> [ActivityInfo]? {
        
        var filteredArray: [ActivityInfo] = []
        for (_, activity) in self.activityInfo.enumerated() {
            if (self.activityInfo.count < 1) {
                filteredArray.append(activity)
            } else {
                let activityArray = filteredArray.filter {$0.activityDificulty == activity.activityDificulty && $0.activitySubType == activity.activitySubType}
                if (activityArray.count == 0) {
                    filteredArray.append(activity)
                }
            }
        }
        
        return filteredArray
    }
    
    //MARK:- Table Delegate Methods
    func updateTableViewFrame (sender: UIView) {
        
        var originY: CGFloat = 0.0
        var maxHeight: CGFloat = 0.0
        
        if sender.frame.origin.y > 420 {
            maxHeight = self.view.frame.size.height + sender.frame.origin.y
        } else {
            maxHeight = self.view.frame.size.height - sender.frame.origin.y + sender.frame.size.height - self.addActivityButton.frame.size.height - 100
        }
        
        var height = CGFloat((self.dropDownTableView?.numberOfSections)! * 47)
        height = height > maxHeight ? maxHeight : height
        
        if sender.frame.origin.y > 420 {
            originY = sender.frame.origin.y - height + 2
        } else {
            originY = sender.frame.origin.y + sender.frame.size.height - 2
        }
        
        self.dropDownTableView.frame = CGRect(x:sender.frame.origin.x, y:originY, width:sender.frame.size.width,  height:height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropDownCell")
        let activityInfo = self.dataArray[indexPath.section]
        
        if self.showGropName == true {
            if let aType = activityInfo.activityType {
                var nameString = aType
                
                if let aSubType =  activityInfo.activitySubType, aSubType != "" {
                    nameString = "\(aSubType)"
                }
                if let aDifficulty = activityInfo.activityDificulty, aDifficulty != "" {
                    nameString = "\(nameString) - \(aDifficulty)"
                }
                
                cell!.textLabel!.text = nameString
            }
        } else if self.showCheckPoint == true {
            cell!.textLabel!.text = activityInfo.activityCheckPoint!
        } else {
            cell!.textLabel!.text = activityInfo.activityTag!
            if activityInfo.activityTag! == "" {
                cell!.textLabel!.text = "(none)"
            }
        }
        
        return cell!
    }
    
    func closeDropDown () {
        self.dataArray.removeAll()
        self.dropDownTableView?.reloadData()
        self.dropDownTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < self.dataArray.count {
            
            self.showCheckPoint = self.showCheckPoint == true ? false : false
            self.showGropName = self.showGropName == true ? false : false
            self.showDetail = self.showDetail == true ? false : false
            
            self.updateViewWithActivity(activityInfo: self.dataArray[indexPath.section])
            self.closeDropDown()
        }
    }
    
    func getActivitiesFilteredSubDifficultyCheckPoint (activity: ActivityInfo) -> [ActivityInfo]? {
        let activityArray = self.activityInfo.filter {$0.activitySubType == activity.activitySubType && $0.activityDificulty == activity.activityDificulty && $0.activityCheckPoint == activity.activityCheckPoint
        }
        return activityArray
    }
    
    //MARK:- Bounded Box Labels
    func addModifiersView () {
        
        var mofifiersArray: [String] = []
        
        if let _ = self.selectedActivity?.activityModifiers.count,
            (self.selectedActivity?.activityModifiers.count)! > 0 {
            for modifiers in (self.selectedActivity?.activityModifiers)! {
                mofifiersArray.append(modifiers.aModifierName!)
            }
            
            for bonus in (self.selectedActivity?.activityBonus)! {
                mofifiersArray.append(bonus.aBonusName!)
            }
        } else {
            if let hasCheckPoint = self.selectedActivity?.activityCheckPoint, hasCheckPoint != ""{
                mofifiersArray.append(hasCheckPoint)
            }
        }
        
        
        self.keys.removeAll()
        self.keys = mofifiersArray
        self.reloadButtons()
    }
    
    
    
    private func reloadButtons() {
        for button in self.searchScrollView.subviews {
            button.removeFromSuperview()
        }
        var previousRect = CGRect.zero
        var initialPointInRow = CGPoint.zero
        var found = false
        for i in 0 ..< keys.count {
            let key = keys[i]
            let giphyButton = UIButton()
            giphyButton.layer.borderColor = UIColor.white.cgColor
            giphyButton.layer.borderWidth = 1.0
            giphyButton.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 10)
            giphyButton.setTitle(key.uppercased(), for: .normal)
            let newRect = calculateNewFrame(previousRect: previousRect, keyToDisplay: key.uppercased())
            if newRect.origin.y != initialPointInRow.y {
                //another row
                let remainingSpace = (self.searchScrollView.frame.size.width - (previousRect.origin.x + previousRect.size.width))/2
                for button in self.searchScrollView.subviews {
                    if button.frame.origin.y == initialPointInRow.y && !found {
                        button.frame = CGRect(x:button.frame.origin.x+remainingSpace, y:button.frame.origin.y, width:button.frame.size.width, height: button.frame.size.height)
                    }
                }
                found = true
                initialPointInRow = newRect.origin
            } else {
                found = false
            }
            previousRect = newRect
            giphyButton.frame = previousRect
            giphyButton.tag = i
            self.searchScrollView.addSubview(giphyButton)
            self.searchScrollView.contentSize = CGSize(width:self.searchScrollView.frame.size.width, height:previousRect.origin.y+previousRect.size.height)
            if i == keys.count-1 {
                let remainingSpace = (self.searchScrollView.frame.size.width - (giphyButton.frame.origin.x + giphyButton.frame.size.width))/2
                for button in self.searchScrollView.subviews {
                    if button.frame.origin.y == giphyButton.frame.origin.y {
                        button.frame = CGRect(x:button.frame.origin.x+remainingSpace, y: button.frame.origin.y, width:button.frame.size.width, height:button.frame.size.height)
                    }
                }
            }
        }
    }
    
    private func calculateNewFrame(previousRect:CGRect, keyToDisplay:String) -> CGRect {
        let rect:CGRect = "\(keyToDisplay)".boundingRect(with: CGSize(width:self.searchScrollView.frame.size.width, height:0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 10)!], context: nil)
        let requiredSpaceForKey = rect.size.width + 20
        var initialPoint = previousRect.origin.x + previousRect.size.width
        if initialPoint != 0.0 {
            initialPoint += 8.0
        }
        if initialPoint + requiredSpaceForKey < self.searchScrollView.frame.size.width {
            return CGRect(x:initialPoint, y:previousRect.origin.y, width:requiredSpaceForKey, height:22)
        } else {
            if requiredSpaceForKey < self.searchScrollView.frame.size.width {
                return CGRect(x:0, y:previousRect.origin.y+previousRect.size.height+8, width: requiredSpaceForKey, height:22)
            } else {
                return CGRect(x:0, y:previousRect.origin.y+previousRect.size.height+8, width:self.searchScrollView.frame.size.width, height:22)
            }
        }
    }
    
    
    deinit {
        
    }
}
