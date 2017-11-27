//
//  ChannelVC.swift
//  SlackClone
//
//  Created by dubie on 11/7/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class ChannelVC: NSViewController {

    // Outlets
    @IBOutlet weak var addChannelBtn: NSButton!
    @IBOutlet weak var userNameLbl: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear() {
        setupView()
        
    }
    
    func setupView(){
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        view.wantsLayer = true
        view.layer?.backgroundColor = chatPurple.cgColor
        
        userNameLbl.stringValue = ""
        addChannelBtn.styleButtonText(button: addChannelBtn, buttonName: "Add +", fontColor: .controlColor, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
    }
    
    @IBAction func addChannelButtonClicked(_ sender: Any) {
        print("add channel clicked")
        if AuthService.instance.isLoggedIn {
            //modal
        } else {
            let modalDict = [USER_INFO_MODAL: ModalType.login]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: modalDict)
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn {
            userNameLbl.stringValue = UserDataService.instance.name
        } else {
            userNameLbl.stringValue = ""
        }
    }
    
    
}
