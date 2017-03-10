//
//  EventDetailViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/20/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import pop
import SDWebImage

class EventDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CustomErrorDelegate, InvitationViewProtocol, UIGestureRecognizerDelegate {
    
    
    private let EVENT_DESCRIPTION_CELL = "eventDescriptionCell"
    private let EVENT_COMMENT_CELL = "eventCommentCell"
    
    //Cell Height
    private let event_description_row_height: CGFloat = 54
    
    //Segment Control
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var segmentOneUnderLine: UIImageView?
    @IBOutlet weak var segmentTwoUnderLine: UIImageView?
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTag: InsertLabel!
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var eventCheckPoint_Time: UILabel!
    @IBOutlet weak var eventBackGround: UIImageView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    //Chat View
    @IBOutlet weak var chatTextBoxView: UIView!
    @IBOutlet weak var chatTextView: CustomUITextView!
    
    //Event Full View
    @IBOutlet weak var fullViews: UIView!
    @IBOutlet weak var fullViewsheaderLabel: UILabel!
    @IBOutlet weak var fullViewsDescriptionLabel: UILabel!
    
    //LayOut Constraints
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventInfoTableTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var eventFullViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var eventFullViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var backgroundImageHeightConstraint: NSLayoutConstraint?

    //Invitation View
    @IBOutlet var invitationButtonsView: UIView!
    @IBOutlet var leaveInvitationButton: UIButton!
    @IBOutlet var confirmInvitationButton: UIButton!
    var inviteView: InviteView = InviteView()
    var isShowingInvitation: Bool = false
    var keyBoardHeight: CGFloat!
    var userToKick: PlayerInfo?
    @IBOutlet weak var invitationViewOverLay: UIImageView!
    
    
    //Current Event
    var eventInfo: EventInfo?
    var hasTag: Bool = false
    var hasCheckPoint: Bool = false
    var isFutureEvent: Bool = false
    var chatViewOriginalContentSize: CGSize?
    var chatViewOriginalFrame: CGRect?
    var selectedComment: CommentInfo?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let _ = self.eventInfo else {
            return
        }
        
        //TextView Delegate
        self.chatTextView?.layer.cornerRadius = 4.0
        self.chatTextView?.text = "Type your comment here"
        self.chatTextView?.textColor = UIColor.lightGray
        self.chatTextView.layer.cornerRadius = 3.0
        
        //        Key Board Observer
        NotificationCenter.default.addObserver(self, selector: #selector(EventDetailViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(EventDetailViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
        
        self.segmentControl?.removeBorders()
        
        let boldFont = UIFont(name: "Helvetica-Bold", size: 14.0)
        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName as NSObject : UIColor.white,
            NSFontAttributeName as NSObject : boldFont!,
            ]
        
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, for: .normal)
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, for: .selected)
        
        if let hasImage = self.eventInfo?.eventActivity?.activityIconImage,
            let imageURL = URL(string: hasImage){
            self.eventIcon.sd_setImage(with: imageURL)
        }
        
        if let hasTag = self.eventInfo?.eventActivity?.activityTag, hasTag != "" {
            self.eventTag.text = hasTag
            self.eventTag.layer.cornerRadius = 2
            self.eventTag.clipsToBounds = true
            self.hasTag = true
        } else {
            self.eventTag.isHidden = true
        }
        
        //Activity Name Label
        if var eventType = self.eventInfo?.eventActivity?.activityType {
            if let hasDifficulty = self.eventInfo?.eventActivity?.activityDificulty, hasDifficulty != "" {
                eventType = "\(eventType) - \(hasDifficulty)"
            }
            self.eventName.text = eventType
        }
        
        
        // Table View
        self.eventTable?.register(UINib(nibName: "EventDescriptionCell", bundle: nil), forCellReuseIdentifier: EVENT_DESCRIPTION_CELL)
        self.eventTable?.register(UINib(nibName: "EventCommentCell", bundle: nil), forCellReuseIdentifier: EVENT_COMMENT_CELL)
        self.eventTable?.estimatedRowHeight = event_description_row_height
        self.eventTable?.rowHeight = UITableViewAutomaticDimension
        self.eventTable?.setNeedsLayout()
        self.eventTable?.layoutIfNeeded()
        
        if let hasCheckPoint = self.eventInfo?.eventActivity?.activitySubType, hasCheckPoint != "" {
            self.hasCheckPoint = true
            let checkPoint = hasCheckPoint
            let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 195/255, blue: 0/255, alpha: 1)]
            
            let checkAttributedStr = NSAttributedString(string: checkPoint + "  ", attributes: stringColorAttribute)
            
            let finalString:NSMutableAttributedString = checkAttributedStr.mutableCopy() as! NSMutableAttributedString
            
            if self.eventInfo?.isFutureEvent == true {
                self.isFutureEvent = true
                
                
                if let hasLaunchDate = self.eventInfo?.eventLaunchDate {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    if let eventDate = formatter.date(from: hasLaunchDate) {
                        let nextFormatter = DateFormatter()
                        if eventDate.daysFrom(date: Date()) < 7 {
                            nextFormatter.dateFormat = "EEEE 'at' h:mm a"
                            let time = nextFormatter.string(from: eventDate)
                            let timeAttributedStr = NSAttributedString(string: time, attributes: nil)
                            finalString.append(timeAttributedStr)
                        } else {
                            nextFormatter.dateFormat = "MMM d 'at' h:mm a"
                            let time = nextFormatter.string(from: eventDate)
                            let timeAttributedStr = NSAttributedString(string: time, attributes: nil)
                            finalString.append(timeAttributedStr)
                        }
                    }
                }
            }
            
            self.eventCheckPoint_Time?.attributedText = finalString
        } else if (self.eventInfo?.isFutureEvent == true){
            self.isFutureEvent = true
            
            if let hasLaunchDate = self.eventInfo?.eventLaunchDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                if let eventDate = formatter.date(from: hasLaunchDate) {
                    let nextFormatter = DateFormatter()
                    if Date().daysFrom(date: eventDate) < 7 {
                        nextFormatter.dateFormat = "EEEE 'at' h:mm a"
                        let time = nextFormatter.string(from: eventDate)
                        let timeAttributedStr = NSAttributedString(string: time, attributes: nil)
                        self.eventCheckPoint_Time?.attributedText = timeAttributedStr
                    } else {
                        nextFormatter.dateFormat = "MMM d 'at' h:mm a"
                        let time = nextFormatter.string(from: eventDate)
                        let timeAttributedStr = NSAttributedString(string: time, attributes: nil)
                        self.eventCheckPoint_Time?.attributedText = timeAttributedStr
                    }
                }
            }
        } else {
            self.eventCheckPoint_Time.isHidden = true
        }
        
        self.reloadButton()
        
        let block: SDExternalCompletionBlock = {(newImage, error, cacheType, imageURL) -> Void in
            if let anImage = newImage, error == nil {
                self.eventBackGround.image = anImage
                self.backgroundImageHeightConstraint?.constant = (ScreenSize.SCREEN_WIDTH*anImage.size.height)/anImage.size.width
            } else {
                self.eventBackGround.image = UIImage(named: "imgBGEventDetail")
                let defaultRadio:CGFloat = 1.5432
                self.backgroundImageHeightConstraint?.constant = ScreenSize.SCREEN_WIDTH/defaultRadio
            }
            self.view.layoutIfNeeded()
        }
        
        if let hasImage = self.eventInfo?.eventActivity?.activityImage, hasImage != "",
            let imageURL = URL(string: hasImage) {
            self.eventBackGround.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "imgBGEventDetail"), options: SDWebImageOptions(rawValue: 0), completed: block)
        }
        
        
        //Update Comment Count
        if let hasComments = self.eventInfo?.eventComments.count {
            let commentString = "COMMENTS (\(hasComments))"
            self.segmentControl?.setTitle(commentString, forSegmentAt: 1)
        }
        
        
        //Full Event View's Text Labels
        if ApplicationManager.sharedInstance.currentUser?.userID != self.eventInfo?.eventCreator?.playerID {
            if let creatorTag = self.eventInfo?.eventPlayersArray.first?.playerConsoleId {
                self.fullViewsDescriptionLabel?.text = "Send \(creatorTag) a friend request or message for an invite."
                self.eventFullViewHeightConstraint?.constant = 80
            }
        } else {
            self.fullViewsDescriptionLabel?.text = "Expect friend requests or messages from your team. You can start the party and invite everyone."
            self.eventFullViewHeightConstraint?.constant = 98
        }
        
        self.fullViews?.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.chatViewOriginalContentSize = self.chatTextView?.contentSize
        self.chatViewOriginalFrame = self.chatTextView?.frame
        
        ApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentViewForDetailView(parentViewController: self, withEvent: self.eventInfo!)
        
        self.showEventFullView(isKeyBoardOpen: false)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove FireBase Observer
        if let _ = self.eventInfo {
            ApplicationManager.sharedInstance.fireBaseManager?.removeDetailObserver(withEvent: self.eventInfo!)
        }
        
        //Remove FireBase Comment Observer
        ApplicationManager.sharedInstance.fireBaseManager?.removeCommentsObserver(withEvent: self.eventInfo!)
    }
    
    func reloadButton () {
        
        self.joinButton.removeTarget(nil, action: nil, for: .allEvents)
        self.chatTextBoxView?.isHidden = true
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            let isCurrentUserInTheEvent = ApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event: self.eventInfo!)
            if isCurrentUserInTheEvent == true {
                self.joinButton.isHidden = false
                self.joinButton?.addTarget(self, action: #selector(leaveEvent), for: .touchUpInside)
                self.joinButton?.setTitle("LEAVE", for: .normal)
                self.joinButton.backgroundColor = UIColor.cyan
                self.joinButton?.backgroundColor = UIColor(red: 0/255, green: 194/255, blue: 255/255, alpha: 1)
                self.tableViewBottomConstraint.constant = 0
            } else {
                if self.eventInfo?.eventPlayersArray.count == self.eventInfo?.eventMaxPlayers?.intValue {
                    self.joinButton.isHidden = true
                    self.tableViewBottomConstraint.constant = -(self.joinButton?.frame.size.height)!
                } else {
                    self.joinButton.isHidden = false
                    self.joinButton?.addTarget(self, action: #selector(joinAnEvent), for: .touchUpInside)
                    self.joinButton?.setTitle("JOIN", for: .normal)
                    self.tableViewBottomConstraint.constant = 0
                    self.joinButton?.backgroundColor = UIColor(red: 250/255, green: 148/255, blue: 0/255, alpha: 1)
                }
            }
        } else {
            self.tableViewScrollToBottom(animated: true)
            let isCurrentUserInTheEvent = ApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event: self.eventInfo!)
            if isCurrentUserInTheEvent == true {
                self.chatTextBoxView?.isHidden = false
                self.sendMessageButton.removeTarget(nil, action: nil, for: .allEvents)
                self.sendMessageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
                self.tableViewBottomConstraint.constant = 0
            } else {
                if self.eventInfo?.eventPlayersArray.count == self.eventInfo?.eventMaxPlayers?.intValue {
                    self.joinButton.isHidden = true
                    self.tableViewBottomConstraint.constant = -(self.joinButton?.frame.size.height)!
                } else {
                    self.joinButton.isHidden = false
                    self.joinButton?.addTarget(self, action: #selector(joinAnEvent), for: .touchUpInside)
                    self.joinButton.setTitle("JOIN", for: .normal)
                    self.tableViewBottomConstraint.constant = 0
                }
            }
        }
    }
    
    //MARK:- IB_ACTIONS
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        if self.chatTextView?.isFirstResponder == true {
            self.chatTextView.resignFirstResponder()
        }
    }
    
    @IBAction func dismissButton (sender: UIButton) {
        
        if self.chatTextView?.isFirstResponder == true {
            self.chatTextView.resignFirstResponder()
        }
        
        self.dismissViewController(isAnimated: true) { (didDismiss) in
            
        }
    }
    
    @IBAction func shareButton (sender: UIButton) {
        
        if let _ = self.eventInfo?.eventID {
            var myEventDict = [String: AnyObject]()
            myEventDict["eventId"] = self.eventInfo?.eventID as AnyObject?
            let trackingRequest = AppTrackingRequest()
            trackingRequest.sendApplicationPushNotiTracking(notiDict: myEventDict as NSDictionary?, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_EVENT_SHARING, completion: {didSucceed in
            })
        }
        
        ApplicationManager.sharedInstance.branchManager?.createLinkWithBranch(eventInfo: self.eventInfo!, deepLinkType: BRANCH_DEEP_LINKING_END_POINT.EVENT_DETAIL.rawValue, callback: {(url, error) in
            if (error == nil) {
                // Group to Share
                let groupToShare = [url as AnyObject] as [AnyObject]
                
                let activityViewController = UIActivityViewController(activityItems: groupToShare , applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            } else {
                print("Branch TestBed: \(error)")
            }
        })
    }
    
    @IBAction func segmentControlSelection (sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.segmentOneUnderLine?.isHidden = false
            self.segmentTwoUnderLine?.isHidden = true
            
            ApplicationManager.sharedInstance.fireBaseManager?.removeCommentsObserver(withEvent: self.eventInfo!)
            break;
        case 1:
            self.segmentOneUnderLine?.isHidden = true
            self.segmentTwoUnderLine?.isHidden = false
            
            ApplicationManager.sharedInstance.fireBaseManager?.addCommentsObserversWithParentViewForDetailView(parentViewController: self, withEvent: self.eventInfo!)
            break;
        default:
            break;
        }
        
        //Reload Data
        self.reloadEventTable()
        self.reloadButton()
    }
    
    
    //MARK:- Table View Delegates
    func tableViewScrollToBottom(animated: Bool) {
        if self.segmentControl?.selectedSegmentIndex == 1 {
            if (self.eventInfo?.eventComments.count)! < 1 {
                return
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let numberOfSections = self.eventTable?.numberOfSections,
            let numberOfRows = self.eventTable?.numberOfRows(inSection: numberOfSections-1),
            numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.eventTable?.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.segmentControl?.selectedSegmentIndex == 0 {
            if section == 0 {
                let headerView = UILabel()
                headerView.text = self.eventInfo?.clanName
                headerView.textAlignment = .center
                headerView.textColor = UIColor.white
                headerView.font = UIFont(name:"HelveticaNeue", size: 12)
                headerView.backgroundColor = UIColor(red: 53/255, green: 65/255, blue: 91/255, alpha: 1)
                
                return headerView
            }
        }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.segmentControl?.selectedSegmentIndex == 0 {
            if section == 0 {
                return 44.0
            }
        }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.segmentControl?.selectedSegmentIndex == 0 {
            if let activityMaxPlayers = self.eventInfo?.eventActivity?.activityMaxPlayers {
                return activityMaxPlayers.intValue
            }
            if let count = self.eventInfo?.eventPlayersArray.count {
                return count
            }
        } else {
            if let count = self.eventInfo?.eventComments.count {
                return count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: EventDescriptionCell?
        
        if segmentControl?.selectedSegmentIndex == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: EVENT_DESCRIPTION_CELL) as? EventDescriptionCell
            self.eventTable?.rowHeight = event_description_row_height
            
            if indexPath.section < (self.eventInfo?.eventPlayersArray.count)! {
                
                // Player USERNAME CLAN-TAG
                var playersNameString = self.eventInfo?.eventPlayersArray[indexPath.section].playerConsoleId
                if var clanTag = self.eventInfo?.eventPlayersArray[indexPath.section].playerClanTag, clanTag != "" {
                    clanTag = " " + "[" + clanTag + "]"
                    if self.eventInfo?.eventPlayersArray[indexPath.section].playerID != ApplicationManager.sharedInstance.currentUser?.userID {
                        playersNameString = playersNameString! + clanTag
                    } else if (UserInfo.isUserVerified()! == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                        playersNameString = playersNameString! + clanTag
                    }
                }
                
                cell?.playerUserName.text = playersNameString
                cell?.playerUserName?.textColor = UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)
                cell?.playerIcon.roundRectView (borderWidth: 1, borderColor: UIColor.gray)
                cell?.playerInviteButton.isHidden = true
                
                //Add Player Object to Cancel/ Kick Button
                if let playerObj = self.eventInfo?.eventPlayersArray[indexPath.section] {
                    cell?.invitationButton.buttonPlayerInfo = playerObj
                }
                
                
                //Add Invitation Invitor Blue Bar Logic
                if let playerID = self.eventInfo?.eventPlayersArray[indexPath.section].playerID {
                    if self.isInvitor(playerID: playerID) == true {
                        cell?.blueBarView.isHidden = false
                    } else {
                        //Add Invitation Label Logic
                        self.addInvitationLabelLogic(inviCell: cell!, playerInfo: (self.eventInfo?.eventPlayersArray[indexPath.section])!)
                    }
                }
                
                //ADD KICK Logic if Event is FULL, also the player should not be the invited one
                if self.eventInfo?.eventFull() == true {
                    if let playerInfo = self.eventInfo?.eventPlayersArray[indexPath.section] {
                        let isCurrentUserInTheEvent = ApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event: self.eventInfo!)
                        if let isInvited = playerInfo.invitedBy, isInvited != "" {
                            
                        } else if playerInfo.isPlayerActive == false && eventInfo?.isFutureEvent == false && playerInfo.playerID != ApplicationManager.sharedInstance.currentUser?.userID && isCurrentUserInTheEvent == true {
                            cell?.invitationButton?.isHidden = false
                            cell?.invitationButton?.setTitle("Kick", for: UIControlState.normal)
                            cell?.invitationButton?.removeTarget(nil, action: nil, for: .allEvents)
                            cell?.invitationButton?.addTarget(self, action: #selector(showKickUserView), for: .touchUpInside)
                        }
                    }
                }
                
                // User Avator if user is not VERIFIED
                cell?.playerIcon.image = UIImage(named: "avatar")
                if let hasImage = self.eventInfo?.eventPlayersArray[indexPath.section].playerImageUrl,
                    hasImage != "",
                    let imageURL = URL(string: hasImage) {
                    cell?.playerIcon.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "avatar"))
                }
                
                
                //Add DogTag to the event creator
                if self.eventInfo?.eventPlayersArray[indexPath.section].playerID == self.eventInfo?.eventCreator?.playerID {
                    cell!.creatorDogTag?.isHidden = false
                } else {
                    cell!.creatorDogTag?.isHidden = true
                }
                
                return cell!
            } else {
                cell?.playerIcon?.image = UIImage(named: "iconProfileBlank")
                cell?.playerUserName?.text = "Searching..."
                cell?.playerUserName?.textColor = UIColor.white
                cell?.invitationButton.isHidden = true
                cell?.creatorDogTag.isHidden = true
                
                if (indexPath.section) == self.eventInfo?.eventPlayersArray.count {
                    if ApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event: self.eventInfo!) == true {
                        if self.isCurrentPlayerInvited() == true {
                            cell?.playerInviteButton.isHidden = true
                        } else {
                            cell?.playerUserName?.text = "Searching..."
                            //TODO: invite shouldn't be hidden in Destiny but i should in Overwatch 
                            cell?.playerInviteButton.isHidden = true
                            cell?.playerInviteButton.addTarget(self, action: #selector(inviteUser), for: .touchUpInside)
                        }
                    } else {
                        cell?.playerInviteButton.isHidden = true
                    }
                } else {
                    cell?.playerInviteButton.isHidden = true
                }
                
                return cell!
            }
        } else {
            let commentCell: EventCommentCell = (tableView.dequeueReusableCell(withIdentifier: EVENT_COMMENT_CELL) as? EventCommentCell)!
            
            commentCell.playerIcon.image = UIImage(named: "avatar")
            if let hasImage = self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userImageURL!,
                hasImage != "",
                let imageURL = URL(string: hasImage) {
                commentCell.playerIcon.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "avatar"))
            }
            
            if self.eventInfo?.eventComments[indexPath.section].commentReported == true {
                commentCell.playerComment.text = "[comment removed]"
                commentCell.messageTopConst?.constant = -10
                commentCell.messageBottomConst?.constant = -10
            } else {
                //Check if User is part of the event && comment shouldnt be marked as Reported
                if let playerID = self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userID {
                    if self.eventInfo?.isUserPartOfEvent(userID: playerID) == false {
                        commentCell.playerComment?.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)
                        commentCell.playerUserName?.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)
                        commentCell.playerIcon?.image = UIImage(named: "iconProfileBlank")
                    } else {
                        commentCell.playerComment?.textColor = UIColor.white
                        commentCell.playerUserName?.textColor = UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)
                    }
                }
                
                commentCell.messageTopConst?.constant = 5
                commentCell.messageBottomConst?.constant = 0
                commentCell.playerComment.text = self.eventInfo?.eventComments[indexPath.section].commentText!
            }
            
            self.eventTable?.estimatedRowHeight = event_description_row_height
            self.eventTable?.rowHeight = UITableViewAutomaticDimension
            
            
            var playersNameString = self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.consoleId!
            if var clanTag = self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.getDefaultConsole()?.clanTag, clanTag != "" {
                clanTag = " " + "[" + clanTag + "]"
                if self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userID != ApplicationManager.sharedInstance.currentUser?.userID {
                    playersNameString = playersNameString! + clanTag
                } else if (UserInfo.isUserVerified()! == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                    playersNameString = playersNameString! + clanTag
                }
            }
            
            commentCell.playerUserName.text = playersNameString
            commentCell.playerIcon.roundRectView (borderWidth: 1, borderColor: UIColor.gray)
            
            if let hasTime = self.eventInfo?.eventComments[indexPath.section].commentCreated {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                if let updateDate = formatter.date(from: hasTime) {
                    commentCell.messageTimeLabel?.text = updateDate.relative()
                } else {
                    commentCell.messageTimeLabel?.text = ""
                }
            }
            
            
            if self.eventInfo?.eventComments[indexPath.section].commentReported == true {
                commentCell.playerIcon.image = UIImage(named: "accountCircle")
                commentCell.playerUserName.isHidden = true
            } else {
                commentCell.playerUserName.isHidden = false
            }
            
            //Add DogTag to the event creator
            if self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userID == self.eventInfo?.eventCreator?.playerID {
                commentCell.creatorDogTag?.isHidden = false
            } else {
                commentCell.creatorDogTag?.isHidden = true
            }
            
            
            return commentCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentControl?.selectedSegmentIndex == 1 {
            self.chatTextView.resignFirstResponder()
            
            if (self.eventInfo?.eventComments[indexPath.section].commentReported == true)  {
                return
            } else if (ApplicationManager.sharedInstance.currentUser?.hasReachedMaxReportedComments == true) {
                self.selectedComment = self.eventInfo?.eventComments[indexPath.section]
                let errorView = Bundle.main.loadNibNamed("CustomErrorUserAction", owner: self, options: nil)?[0] as! CustomError
                errorView.errorMessageHeader?.text = "REPORT ISSUE"
                errorView.errorMessageDescription?.text = "Looks like you’ve sent several reports recently. This probably needs our attention! Please tell us more about this issue."
                errorView.frame = self.view.frame
                errorView.delegate = self
                
                self.view.addSubviewWithLayoutConstraint(newView: errorView)
            } else {
                self.selectedComment = self.eventInfo?.eventComments[indexPath.section]
                let errorView = Bundle.main.loadNibNamed("CustomErrorUserAction", owner: self, options: nil)?[0] as! CustomError
                errorView.errorMessageHeader?.text = "REPORT ISSUE"
                errorView.errorMessageDescription?.text = "Is this comment problematic? Reporting it will hide it from everyone. Let us know more at support@crossroadsapp.co"
                errorView.frame = self.view.frame
                errorView.delegate = self
                
                self.view.addSubviewWithLayoutConstraint(newView: errorView)
            }
        }
    }
    
    func inviteUser (sender: UIButton) {
        
        //This intercepts the touch and disables double tapping of invite button
        self.invitationViewOverLay?.isHidden = false
        
        self.inviteView = Bundle.main.loadNibNamed("InviteView", owner: self, options: nil)?[0] as! InviteView
        inviteView.setUpView()
        inviteView.frame = CGRect(x:0, y:inviteView.bounds.size.height, width:inviteView.frame.size.width, height:inviteView.frame.size.height)
        let trans = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
        trans?.fromValue = NSValue(cgPoint: CGPoint(x:0, y:inviteView.bounds.size.height))
        trans?.toValue = NSValue(cgPoint: CGPoint(x:0, y:0))
        inviteView.layer.pop_add(trans, forKey: "Translation")
        
        let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        popAnimation.toValue = 1.0
        popAnimation.duration = 0.4
        inviteView.pop_add(popAnimation, forKey: "alphasIn")
        
        self.isShowingInvitation = true
        self.inviteView.delegate = self
        self.inviteView.eventInfo = self.eventInfo
        self.view.addSubviewWithLayoutConstraint(newView: inviteView)
    }
    
    //Custom Error Delegate Method
    func customErrorActionButtonPressed() {
        
        guard let _ = self.selectedComment else { return }
        
        if ApplicationManager.sharedInstance.currentUser?.hasReachedMaxReportedComments == true {
            let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let vc : SendReportViewController = storyboard.instantiateViewController(withIdentifier: K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as! SendReportViewController
            vc.eventID = self.eventInfo?.eventID
            vc.commentID = (self.selectedComment?.commentId)!
            
            let navigationController = BaseNavigationViewController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            let reportRequest = ReportComment()
            reportRequest.reportAComment(commentID: (self.selectedComment?.commentId)!, eventID: (self.eventInfo?.eventID)!, reportDetail: nil, reportedEmail: nil, completion: { (didSucceed) in
                if let succeed = didSucceed,
                    succeed {
                    self.selectedComment = nil
                }
            })
        }
    }
    
    func customErrorActionButtonPressedWithSelector(selector: Selector) {
        self.performSelector(inBackground: selector, with: nil)
    }
    
    override func reloadEventTable() {
        
        //Hide Invitation Button
        if isCurrentPlayerInvited() == true {
        } else {
            self.hideInvitationUIButtons()
        }
        
        
        if ApplicationManager.sharedInstance.currentUser?.userID != self.eventInfo?.eventCreator?.playerID {
            if let creatorTag = self.eventInfo?.eventPlayersArray.first?.playerConsoleId {
                self.fullViewsDescriptionLabel?.text = "Send \(creatorTag) a friend request or message for an invite."
                self.eventFullViewHeightConstraint?.constant = 80
            }
        } else {
            self.fullViewsDescriptionLabel?.text = "Expect friend requests or messages from your team. You can start the party and invite everyone."
            self.eventFullViewHeightConstraint?.constant = 98
        }
        
        DispatchQueue.main.async {
            if let _ = self.eventInfo {
                //Update Comment Count
                if let hasComments = self.eventInfo?.eventComments.count {
                    let commentString = "COMMENTS (\(hasComments))"
                    self.segmentControl?.setTitle(commentString, forSegmentAt: 1)
                }
                
                //Reload Data
                self.eventTable?.reloadData()
                self.showEventFullView(isKeyBoardOpen: false)
            }
            
            if self.segmentControl?.selectedSegmentIndex == 1 {
                self.tableViewScrollToBottom(animated: false)
            }
        }
        
    }
    
    //MARK:- Network requests
    func leaveEvent (sender: UIButton) {
        
        guard let _ = self.eventInfo else {
            return
        }
        
        let leaveEventRequest = LeaveEventRequest()
        
        leaveEventRequest.leaveAnEvent(self.eventInfo!, completion: { (event) in
            if let _ = event {
                self.eventInfo = event
                self.reloadEventTable()
                self.reloadButton()
            } else {
                self.dismissViewController(isAnimated: true, dismissed: { (didDismiss) in
                })
            }
        })
    }
    
    func joinAnEvent (sender: UIButton) {
        if let eventInfo = self.eventInfo {
            let joinEventRequest = JoinEventRequest()
            joinEventRequest.joinEventWithUserForEvent(UserInfo.getUserID()!, eventInfo: eventInfo, completion: { (event) in
                if let _ = event {
                    self.eventInfo = event
                    self.reloadEventTable()
                    self.reloadButton()
                }
            })
        }
    }
    
    func sendMessage (sender: UIButton) {
        
        if self.chatTextView.text.isEmpty == true {
            return
        }
        
        let trimmedString = self.chatTextView.text.trimmingCharacters(in: .newlines)
        
        if trimmedString.characters.count == 0 {
            return
        }
        
        if self.chatTextView?.isFirstResponder == true {
            self.chatTextView.resignFirstResponder()
        }
        
        if let textMessage = self.chatTextView.text, textMessage != "Type your comment here",
            let eventId = self.eventInfo?.eventID{
            sender.isEnabled = false
            let sendMessage = SendPushMessage()
            sendMessage.sendEventMessage(eventId: eventId, messageString: textMessage, completion: { (didSucceed) in
                sender.isEnabled = true
                if (didSucceed != nil)  {
                    //Clear Text and reset Chat View
                    self.chatTextView?.contentSize = self.chatViewOriginalContentSize!
                    self.chatTextView?.frame = self.chatViewOriginalFrame!
                    self.textViewHeightConstraint.constant = 50
                    self.chatTextView.text = nil
                    self.reloadEventTable()
                } else {
                }
            })
        }
    }
    
    //MARK:- Text View Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.chatTextView.resignFirstResponder()
            self.sendMessage(sender: self.sendMessageButton)
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let rows = (textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom) / textView.font!.lineHeight
        let myRowsInInt: Int = Int(rows)
        
        if (myRowsInInt > 1 && myRowsInInt <= 4) {
            let contentSizeHeight = textView.contentSize.height
            self.textViewHeightConstraint.constant = contentSizeHeight
            self.view.updateConstraints()
            
            self.tableViewScrollToBottom(animated: true)
        }
        
        if textView.text == "" {
            self.textViewHeightConstraint.constant = 50
            self.view.updateConstraints()
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        self.chatTextView?.becomeFirstResponder()
        
        if self.chatTextView?.textColor == UIColor.lightGray {
            self.chatTextView?.text = nil
            self.chatTextView?.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_
        textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type your comment here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [String : AnyObject] = sender.userInfo! as! [String : AnyObject]
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.cgRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.cgRectValue.size
        self.keyBoardHeight = keyboardSize.height
        
        if self.isShowingInvitation == false {
            if keyboardSize.height == offset.height {
                if self.view.frame.origin.y == 0 {
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.view.frame.origin.y -= keyboardSize.height
                    })
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.view.frame.origin.y += keyboardSize.height - offset.height
                })
            }
        }
        
        self.showEventFullView(isKeyBoardOpen: true)
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [String
            : AnyObject] = sender.userInfo! as! [String : AnyObject]
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.cgRectValue.size
        
        if self.view.frame.origin.y == self.view.frame.origin.y - keyboardSize.height {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                if self.isShowingInvitation == false {
                    self.view.frame.origin.y += keyboardSize.height
                } else {
                    self.inviteView.inviteBtnBottomConst.constant = 0
                    self.inviteView.layoutIfNeeded()
                }
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                if self.isShowingInvitation == false {
                    self.view.frame.origin.y = 0
                } else {
                    self.inviteView.inviteBtnBottomConst.constant = 0
                    self.inviteView.layoutIfNeeded()
                }
            })
        }
        
        self.tableViewScrollToBottom(animated: true)
        self.showEventFullView(isKeyBoardOpen: false)
    }
    
    func showEventFullView (isKeyBoardOpen: Bool) {
        if self.eventInfo?.eventFull() == true && ApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event: self.eventInfo!) == true && isKeyBoardOpen == false {
            
            self.view.layoutIfNeeded()
            self.fullViews?.isHidden = false
            UIView.animate(withDuration: 0.4) {
                
                self.fullViews?.alpha = 1
                
                if ApplicationManager.sharedInstance.currentUser?.userID != self.eventInfo?.eventCreator?.playerID {
                    if self.segmentControl?.selectedSegmentIndex == 0 {
                        self.eventInfoTableTopConstraint?.constant = 36
                        self.eventFullViewBottomConstraint?.constant = 80
                    } else {
                        self.eventInfoTableTopConstraint?.constant = 80
                        self.eventFullViewBottomConstraint?.constant = 80
                    }
                } else {
                    if self.segmentControl?.selectedSegmentIndex == 0 {
                        self.eventInfoTableTopConstraint?.constant = 50
                        self.eventFullViewBottomConstraint?.constant = 98
                    } else {
                        self.eventInfoTableTopConstraint?.constant = 98
                        self.eventFullViewBottomConstraint?.constant = 98
                    }
                }
                
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.eventInfoTableTopConstraint?.constant = 0
                self.eventFullViewBottomConstraint?.constant = 0
            }
            
            self.fullViews?.alpha = 0
        }
        
        //Bring Full event view Z level on top of everything
        self.view.bringSubview(toFront: self.fullViews)
    }
    
    
    //MARK:-Invitation View Delegate
    func invitationViewClosed () {
        self.isShowingInvitation = false
        self.invitationViewOverLay?.isHidden = true
    }
    
    func closeViewAndShowEventCreation () {
        self.dismissViewController(isAnimated: true) { (didDismiss) in
            
        }
    }
    
    func showInviteButton () {
        
        self.inviteView.inviteButton?.isHidden = false
        if let _ = self.keyBoardHeight {
            self.inviteView.inviteBtnBottomConst.constant = self.keyBoardHeight
            self.inviteView.layoutIfNeeded()
        }
    }
    
    func hideInviteButton () {
        self.inviteView.inviteButton?.isHidden = true
        self.inviteView.inviteBtnBottomConst.constant = 0
        self.inviteView.layoutIfNeeded()
    }
    
    
    //MARK:- Invitation Cell UI Logic
    func addInvitationLabelLogic (inviCell: EventDescriptionCell, playerInfo: PlayerInfo) {
        
        if let isInvited = playerInfo.invitedBy, isInvited != "" {
            inviCell.invitationButton.isHidden = false
            inviCell.blueBarView.isHidden = false
            inviCell.playerUserName?.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)
            
            if isInvited == ApplicationManager.sharedInstance.currentUser?.userID {
                inviCell.invitationButton?.removeTarget(nil, action: nil, for: .allEvents)
                inviCell.invitationButton?.setTitle("Cancel", for: UIControlState.normal)
                inviCell.invitationButton?.addTarget(self, action: #selector(cancelInvitation), for: .touchUpInside)
            } else {
                inviCell.invitationButton?.setTitle("Invited", for: UIControlState.normal)
                inviCell.invitationButton?.removeTarget(nil, action: nil, for: .allEvents)
                
                if playerInfo.playerID == ApplicationManager.sharedInstance.currentUser?.userID {
                    self.addInvitationUIButtons()
                }
            }
        } else {
            inviCell.blueBarView.isHidden = true
            inviCell.invitationButton.isHidden = true
            inviCell.playerUserName?.textColor = UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)
        }
    }
    
    func isInvitor (playerID: String) -> Bool {
        let invitor = self.eventInfo?.eventPlayersArray.filter {$0.invitedBy == playerID}
        if (invitor?.count)! > 0 {
            return true
        }
        
        return false
    }
    
    func cancelInvitation (sender: UIButton) {
        let eventBtn = sender as! EventButton
        if let canceledButton = eventBtn.buttonPlayerInfo,
            let eventId = self.eventInfo?.eventID,
            let playerId = canceledButton.playerID{
            let cancelRequest = CancelEventInvitationRequest()
            cancelRequest.cancelInvitationRequest(eventID: eventId, playerID: playerId, completion: {(error, response) in
                if let theError = error {
                    print("Error: \(theError)")
                }
            })
        }
    }
    
    func addInvitationUIButtons () {
        self.invitationButtonsView?.isHidden = false
    }
    
    func hideInvitationUIButtons () {
        self.invitationButtonsView?.isHidden = true
    }
    
    @IBAction func leaveInvitationButton (sender: UIButton) {
        let errorView = Bundle.main.loadNibNamed("CustomErrorUserAction", owner: self, options: nil)?[0] as! CustomError
        errorView.errorMessageHeader?.text = "CAN’T MAKE IT?"
        errorView.errorMessageDescription?.text = "If you turn down this invite, another Hero will take your spot. Are you sure you want to leave?"
        errorView.frame = self.view.frame
        errorView.delegate = self
        errorView.selector = #selector(leaveEvent)
        errorView.actionButton.setTitle("YES, I WANT TO LEAVE", for: .normal)
        errorView.cancelButton.setTitle("No, I want to stay", for: .normal)
        self.view.addSubview(errorView)
    }
    
    
    func showKickUserView (sender: UIButton) {
        
        let eventBtn = sender as! EventButton
        self.userToKick = eventBtn.buttonPlayerInfo
        
        let errorView = Bundle.main.loadNibNamed("CustomErrorUserAction", owner: self, options: nil)?[0] as! CustomError
        errorView.errorMessageHeader?.text = "KICK FOR INACTIVITY?"
        errorView.errorMessageDescription?.text = "Removing this player will allow another to join instead."
        errorView.frame = self.view.frame
        errorView.delegate = self
        errorView.selector = #selector(kickInActiveUser)
        errorView.actionButton.setTitle("KICK", for: .normal)
        self.view.addSubview(errorView)
    }
    
    func kickInActiveUser (playerID: String) {
        if let playerToKick = self.userToKick?.playerID {
            let kickRequest = KickInActiveUserRequest()
            kickRequest.kickInActiveUser(eventID: (self.eventInfo?.eventID)!, playerID: playerToKick, completion: { (error, response) in
            })
        }
    }
    
    
    func isCurrentPlayerInvited () -> Bool {
        let currentPlayer = self.eventInfo?.eventPlayersArray.filter{$0.playerID == ApplicationManager.sharedInstance.currentUser?.userID}
        let player = currentPlayer?.first
        
        if let isInvited = player?.invitedBy, isInvited != "" {
            return true
        }
        
        return false
    }
    
    @IBAction func confirmInvitationButton (sender: UIButton) {
        if let eventId = self.eventInfo?.eventID {
            let acceptRequest = AcceptEventInvitationRequest()
            acceptRequest.acceptInvitationRequest(eventID: eventId, completion: {(error, event) in
                if let theError = error {
                    print("Error: \(theError)")
                }
                self.eventInfo = event
                self.reloadButton()
                self.reloadEventTable()
            })
        }
    }
    
    //UIGestureRecognizer Delegate methods
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: eventTable))!{
            return false
        }
        return true
    }

    deinit {
        
    }
}

class CustomUITextView: UITextView {
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        return true
    }

}
