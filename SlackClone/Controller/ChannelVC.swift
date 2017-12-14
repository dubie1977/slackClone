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
    
    // Variables
    var selectedChannelIndex = 0
    var selectedChannel: Channel?
    var chatVC: ChatVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear() {
        setupView()
    }
    
    override func viewDidAppear() {
        chatVC = self.view.window?.contentViewController?.childViewControllers[0].childViewControllers[1] as? ChatVC
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
                let channel = MessageService.instance.channels[0]
                self.chatVC?.updateWithChannel(channel: channel)
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
            var isSelected = false
            if row == selectedChannelIndex{
                isSelected = true
            } else {
                isSelected = false
            }
                cell.configureCell(channel: channel, isSelected: isSelected)
            return cell
        }
        return NSTableCellView()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        selectedChannelIndex = tableView.selectedRow
        let channel = MessageService.instance.channels[selectedChannelIndex]
        selectedChannel = channel
        chatVC?.updateWithChannel(channel: channel)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30.0
    }
    
    
}




