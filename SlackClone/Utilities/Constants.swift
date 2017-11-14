//
//  File.swift
//  SlackClone
//
//  Created by dubie on 11/7/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

// Colors
let chatPurple = NSColor(calibratedRed: 0.30, green: 0.22, blue: 0.29, alpha: 1.00)
let chatGreen = NSColor(calibratedRed: 0.22, green: 0.66, blue: 0.68, alpha: 1.00)


// Fonts
let AVENIR_REGULAR = "AvenirNext-Regular"
let AVENIR_BOLD = "AvenirNext-Bold"


// Notifications
let USER_INFO_MODAL = "modalUserInfo"
let USER_INFO_REMOVE_IMMEDIATELY = "modalRemoveImmediately"

let NOTIF_PRESENT_MODAL = Notification.Name("presentModal")
let NOTIF_CLOSE_MODAL = Notification.Name("CloseModal")


// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// URL
let BASE_URL = "https://slackclone1977.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"

// Haders
let HEADER = ["Content-Type": "application/json; charset=utf-8"]


typealias CompleationHandeler = (_ Success: Bool) -> ()
