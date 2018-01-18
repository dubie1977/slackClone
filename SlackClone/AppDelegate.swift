//
//  AppDelegate.swift
//  SlackClone
//
//  Created by dubie on 11/7/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        SocketService.instance.establishConnection()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        SocketService.instance.closeConnection()
    }
    
    func applicationWillHide(_ notification: Notification) {
        UserDataService.instance.isMinimizing = true
    }
    
    func applicationDidUnhide(_ notification: Notification) {
        UserDataService.instance.isMinimizing = false
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


}

