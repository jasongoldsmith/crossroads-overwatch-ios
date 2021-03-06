//
//  Constants.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit

struct K {
    
    struct Tokens {
//        static let Mix_Panle_Token  =   "36578d79d8accf79418b0b42b410aa17"
        #if RELEASE
        static let Mix_Panle_Token  =   "36578d79d8accf79418b0b42b410aa17"
        #else
        static let Mix_Panle_Token  =   "0181296a3a01e24e61b79b82f936f77f"
        #endif
    }
    
    struct keyChainInfo {
        static let UserId = "UserId"
    }
    
    struct SharingPlatformType {
        static let Platform_Branch = "branch"
        static let Platform_Facebook = "facebook"
        static let Platform_UnKnown = "unknown"
        static let Platform_Organic = "organic"
    }
    
    struct UserDefaultKey {
        
        static let APPLICATION_CONFIGURATIONS_PLAYER_DETAIL = "APPLICATION_CONFIGURATIONS_PLAYER_DETAIL"
        static let APPLICATION_CONFIGURATIONS_PSN_URL = "APPLICATION_CONFIGURATIONS_PSN_URL"
        static let APPLICATION_CONFIGURATIONS_XBOX_URL = "APPLICATION_CONFIGURATIONS_XBOX_URL"
        
        static let TR_DID_SHOW_ONBOARDING = "TR_DID_SHOW_ONBOARDING"
        static let INSTALL_INFO_SENT = "INSTALL_INFO_SENT"
        static let Platform_Info_Dict = "Platform_Info_Dict"
        static let FORCED_LOGOUT = "FORCED_LOGOUT"
        static let FORCED_LOGOUT_NEW_SIGN_IN = "FORCED_LOGOUT_NEW_SIGN_IN"
        static let APP_HAS_RUN_KEY = "APP_HAS_RUN"
        static let APP_HAS_SHOWN_GROUP_PICKER = "APP_HAS_SHOWN_GROUP_PICKER"
        
        struct UserAccountInfo {
            static let TR_UserName      = "TR_UserName"
            static let TR_UserPwd       = "TR_UserPwd"
            static let TR_UserID        = "TR_UserID"
            static let TR_USER_IMAGE    = "TR_USER_IMAGE"
            static let TR_USER_CLAN_ID  = "TR_USER_CLAN_ID"
            
            
            static let TR_USER_CONSOLE_ID  = "TR_USER_CONSOLE_ID"
            static let TR_USER_BUNGIE_MEMBERSHIP_ID  = "TR_USER_BUNGIE_MEMBERSHIP_ID"
            static let TR_USER_CONSOLE_TYPE  = "TR_USER_CONSOLE_TYPE"
            static let TR_CONSOLE_VERIFIED  = "TR_CONSOLE_VERIFIED"
            static let TR_CONSOLE_IS_PRIMARY  = "TR_CONSOLE_IS_PRIMARY"
            static let TR_SHOW_LEGAL = "TR_SHOW_LEGAL"
        }
    }
    
    struct Legal {
        static let PP = "PRIVATE_POLICY"
        static let TOS = "TERMS_OF_SERVICE"
        static let OK = "OK"
        static let TERMS_OF_SERVICE_URL = "http://w3.crossroadsapp.co/owterms"
        static let PRIVACY_POLICY_URL = "http://w3.crossroadsapp.co/owprivacy"
        static let LICENSES_URL = "https://www.crossroadsapp.co/license"
    }
    
    struct Path {
        static let DocumentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    struct TRUrls {
        
//        Live:
//        static let TR_BaseUrl            =   "https://owlive.crossroadsapp.co"
//        Develop:
//        static let TR_BaseUrl            =   "https://overwatch-test-server.herokuapp.com"
        
        #if RELEASE
        static let TR_BaseUrl            =   "https://owlive.crossroadsapp.co"
        #else
        static let TR_BaseUrl            =   "https://overwatch-test-server.herokuapp.com"
        #endif
        
        static let TR_APP_STORE_LINK     =   "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1195213976&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        static let TR_RegisterUrl        =   "/api/v1/auth/register"
        static let TR_LoginUrl           =   "/api/v1/auth/login"
        static let TR_LogoutUrl          =   "/api/v1/auth/logout"
        static let TR_EventListUrl       =   "/api/v1/a/feed/get"
        static let TR_EventCreationUrl   =   "/api/v1/a/event/create"
        static let TR_ActivityListUrl    =   "/api/v1/activity/list"
        static let TR_JoinEventUrl       =   "/api/v1/a/event/join"
        static let TR_LeaveEventUrl      =   "/api/v1/a/event/leave"
        static let TR_REGISTER_DEVICE    =   "/api/v1/a/installation/ios"
        static let TR_SEND_PUSH_MESSAGE  =   "/api/v1/a/messages/send"
        static let TR_SEND_REPORT        =   "/api/v1/a/report/create"
        static let TR_SEND_REPORT_UNAUTH =   "/api/v2/report/create"
        static let TR_UPDATE_USER        =   "/api/v1/a/user/update"
        static let TR_FORGOT_PASSWORD    =   "/api/v1/auth/request/resetPassword"
        static let TR_FETCH_EVENT        =   "/api/v1/a/event/listById"
        static let TR_APP_TRACKING       =   "/api/v2/mixpanel/track"
        static let TR_GET_GROUPS         =   "/api/v1/a/account/group/list"
        static let TR_UPDATE_GROUPS      =   "/api/v1/a/user/updateGroup"
        static let TR_GET_GROUP_BY_ID    =   "/api/v1/a/account/group/search/"
        static let TR_UPDATE_PASSWORD    =   "/api/v1/a/user/updatePassword"
        static let TR_RESEND_VERIFICATION =  "/api/v1/a/account/group/resendBungieMessage"
        static let TR_BUNGIE_USER_AUTH   =   "/api/v1/auth/checkBungieAccount"
        static let TR_GROUP_NOTI_VALUE   =   "/api/v1/a/account/group/mute"
        static let TR_GET_EVENT          =   "/api/v1/a/event/listById"
        static let TR_HELMET_UPDATE      =   "/api/v1/a/account/updateHelmet"
        static let TR_GET_USER           =   "/api/v1/a/user/listById"
        static let TR_ADD_CONSOLE        =   "/api/v1/a/user/addConsole"
        static let TR_CHANGE_CONSOLE     =   "/api/v1/a/user/changePrimaryConsole"
        static let TR_LEGAL_ACCEPTED     =   "/api/v1/a/user/acceptLegal"
        static let TR_SEND_MESSAGE       =   "/api/v1/a/event/addComment"
        static let TR_PUBLIC_FEED        =   "/api/v1/feed/public"
        static let TR_REPORT_COMMENT     =   "/api/v1/a/event/reportComment"
        static let TR_INVITE_PLAYER      =   "/api/v1/a/event/invite"
        static let BUNGIE_FETCH_USER     =   "/api/v1/auth/validateUserLogin"
        static let TR_CONFIGURATION      =   "/api/v1/config"
        static let BUNGIE_INVI_COMPLETION =  "/api/v1/gatewayResponse"
        static let TR_ACCEPT_INVITATION   =  "/api/v1/a/event/invite/accept"
        static let TR_CANCEL_INVITATION   =  "/api/v1/a/event/invite/cancel"
        static let TR_KICK_PLAYER         =  "/api/v1/a/event/kick"
        static let TR_APP_REVIEW          =  "/api/v1/a/user/updateReviewPromptCardStatus"
        static let TR_CHANGE_PASSWORD     =  "/api/v1/a/user/updatePassword"
        static let TR_CHANGE_EMAIL        =  "/api/v1/a/user/updateEmail"
        static let TR_ONBOARDING_COMPLETE =  "/api/v1/a/user/completeOnBoarding"
    }
    
    struct StoryBoard {
        static let StoryBoard_OnBoarding = "OnBoarding"
        static let StoryBoard_Main       = "Main"
    }
    
    struct VIEWCONTROLLER_IDENTIFIERS {
        
        static let VIEW_CONTROLLER_YATRI                   = "yatriView"
        static let ROOT_VIEW_CONTROLLER                    = "rootVC"
        static let VIEWCONTROLLER_SIGNUP                   = "signup"
        static let VIEWCONTROLLER_LOGIN_OPTIONS            = "loginOptions"
        static let VIEWCONTROLLER_EVENT_LIST               = "eventListVC"
        static let VIEWCONTROLLER_CREATE_EVENT             = "createeventvc"
        static let VIEW_CONTROLLER_CREATE_EVENT_ACTIVITY   = "createEventsActivityVC"
        static let VIEW_CONTROLLER_PROFILE                 = "profileVC"
        static let VIEW_CONTROLLER_SEND_REPORT             = "sendReportVC"
        static let VIEW_CONTROLLER_FORGOT_PASSWORD         = "forgotPassword"
        static let VIEW_CONTROLLER_VERIFY_ACCOUNT          = "verifyAccount"
        static let VIEW_CONTROLLER_CHOOSE_GROUP            = "chooseGroup"
        static let VIEW_CONTROLLER_WEB_VIEW                = "legalWebView"
        static let VIEW_CONTROLLER_CREATE_EVENT_FINAL      = "createventfinal"
        static let VIEW_CONTROLLER_EVENT_DESCRIPTION       = "eventDescriptionVC"
        static let VIEW_CONTROLLER_SIGNIN_ERROR            = "SIGINERROR"
        static let VIEW_CONTROLLER_CONTACT_MESSAGE_SENT    = "messageSent"
        static let VIEW_CONTROLLER_WEB_VIEW_SIGNIN         = "webviewVC"
        static let VIEW_CONTROLLER_CHANGE_PASSWORD         = "changePassword"
        static let VIEW_CONTROLLER_CHANGE_EMAIL            = "changeEmail"
    }
    
    struct ActivityType {
        static let WEEKLY   = "Weekly"
        static let RAIDS    = "Raid"
        static let CRUCIBLE = "Crucible"
        static let ARENA    = "Arena"
        static let STRIKES  = "Strike"
        static let PATROL   = "Patrol"
    }
    
    struct NOTIFICATION_TYPE {
        static let REMOTE_NOTIFICATION_WITH_ACTIVE_SESSION      = "RemoteNotificationWithActiveSesion"
        static let APPLICATION_DID_RECEIVE_REMOTE_NOTIFICATION  = "UIApplicationDidReceiveRemoteNotification"
        static let APPLICATION_WILL_TERMINATE                   = "UIApplicationWillTerminateNotification"
        static let APPLICATION_WILL_RESIGN_ACTIVE               = "UIApplicationWillResignActiveNotification"
        static let USER_DATA_RECEIVED_CLOSE_WEBVIEW             = "USER_DATA_RECEIVED_CLOSE_WEBVIEW"
    }
    
    struct ConsoleTypes {
        static let PS4      = "PS4"
        static let PS3      = "PS3"
        static let XBOX360  = "XBOX360"
        static let XBOXONE  = "XBOXONE"
    }
}

enum EVENT_STATUS : String {
    case CAN_JOIN   = "can_join"
    case FULL       = "full"
    case OPEN       = "open"
    case NEW        = "new"
}

enum EVENT_TIME_STATUS: String {
    case UP_COMING  = "upcoming"
    case CURRENT    = "now"
}

enum BRANCH_DEEP_LINKING_END_POINT: String {
    case EVENT_DETAIL = "eventDetail"
    case EVENT_CREATE = "eventCreate"
    case EVENT_INVITATION = "eventInvitation"
}

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

// Used to check what kind of Notification it is.
enum NOTIFICATION_NAME: String {
    case NOTI_LEAVE = "Leave"
    case NOTI_JOIN  = "Join"
    case NOTI_FULL_FOR_CREATOR = "FullForCreator"
    case NOTI_FULL_FOR_EVENT_MEMEBERS = "FullForEventMembers"
    case NOTI_EVENT_FULL = "EventNotFullNotification"
    case NOTI_MESSAGE_PLAYER = "messageFromPlayer"
    
}

enum NOTIFICATION_TRACKABLE: Int {
    case TRACKABLE
}

enum APP_TRACKING_DATA_TYPE: String {
    case TRACKING_EVENT                     = "event"
    case TRACKING_PUSH_NOTIFICATION         = "pushNotification"
    case TRACKING_SIGNUP_INIT               = "signupInit"
    case TRACKING_EVENT_SHARING             = "eventSharing"
    case TRACKING_ADD_CARD_CLICKED          = "adCardInit"
    case TRACKING_APP_INIT                  = "appInit"
    case TRACKING_APP_INSTALL               = "appInstall"
    case TRACKING_ADD_ACTIVITY_CLICKED      = "addActivityInit"
    case TRACKING_SEG_CURRENT_CLICKED       = "currentTabInit"
    case TRACKING_SEG_UPCOMING_CLICKED      = "upcomingTabInit"
    case TRACKING_APP_RESUME                = "appResume"
    case TRACKING_SHOW_PASSWORD             = "showPassword"
}

enum ACCOUNT_VERIFICATION: String {
    case USER_VERIFIED = "VERIFIED"
    case USER_VER_INITIATED = "INITIATED"
    case USER_NOT_VERIFIED = "clan_id_not_set"
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom
        == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}


enum Branch_Error: Error {
    case ACTIVITY_NOT_AVAILABLE
    case MAXIMUM_PLAYERS_REACHED
    case NEEDS_CONSOLE
    case JOIN_BUNGIE_GROUP
}

enum Activity_Type: String {
    case QUICK   = "Quick Play"
    case ARCADE       = "Arcade"
    case COMPETITIVE      = "Competitive Play"
    case PLAYVSAI   = "Play vs. AI"
    case CUSTOM     = "Custom Game"
}

