//
//  MainWindowController.swift
//  SlackClone
//
//  Created by dubie on 11/7/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.delegate = self
        window?.minSize = NSMakeSize(500, 350)
        AuthService.instance.isLoggedIn = false
    
    }
    
    func windowWillMiniaturize(_ notification: Notification) {
        UserDataService.instance.isMinimizing = true
    }
    
    func windowDidMiniaturize(_ notification: Notification) {
        UserDataService.instance.isMinimizing = false
    }

}
