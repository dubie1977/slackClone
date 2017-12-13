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
        tableView.delegate = self
        tableView.dataSource = self
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
            let modalDict = [USER_INFO_MODAL: ModalType.createChannel]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: modalDict)
        } else {
            let modalDict = [USER_INFO_MODAL: ModalType.login]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: modalDict)
        }
    }
    
    func getChannels(){
        MessageService.instance.findAllChannels { (success, msg) in
            if success {
                self.tableView.reloadData()
                //for channel in MessageService.instance.channels{
                //}
            } else {
                debugPrint(msg)
            }
            
        }
        
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn {
            userNameLbl.stringValue = UserDataService.instance.name
            getChannels()
        } else {
            userNameLbl.stringValue = ""
            self.tableView.reloadData()
        }
    }
}

extension ChannelVC: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let channel = MessageService.instance.channels[row]
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "channelCell"), owner: nil) as? ChannelCell{
            
            cell.configureCell(channel: channel)
            return cell
        }
        return NSTableCellView()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30.0
    }
    
    
}




