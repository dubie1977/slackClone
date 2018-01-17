//
//  ChatVC.swift
//  SlackClone
//
//  Created by dubie on 11/7/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class ChatVC: NSViewController, NSTextFieldDelegate {

    // Outlets
    @IBOutlet weak var channelTitileLbl: NSTextField!
    @IBOutlet weak var channelDescriptionLbl: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var typingUserLbl: NSTextField!
    @IBOutlet weak var messageOutlineView: NSView!
    @IBOutlet weak var messageTxt: NSTextField!
    @IBOutlet weak var sendMessageBtn: NSButton!
    
    // Variables
    let user = UserDataService.instance
    var channel: Channel?
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        messageTxt.delegate = self
        
    }
    
    override func viewWillAppear() {
        setupView()
        
    }
    
    func setupView(){
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        SocketService.instance.getMessages { (message) in
            guard let channelId = self.channel?.id else { return }
            if channelId == message.channelId {
                MessageService.instance.messages.append(message)
                self.tableView.reloadData()
                self.tableView.scrollRowToVisible(MessageService.instance.messages.count - 1)
            } else {
                //Ignore - Not the current channel
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = self.channel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != self.user.name && channel == channelId {
                    if numberOfTypers == 0{
                        names = typingUser
                    } else if numberOfTypers < typingUsers.capacity-1 {
                        names = "\(names), \(typingUser)"
                    } else {
                        names = "\(names) and \(typingUser) are typing"
                    }
                    numberOfTypers = numberOfTypers+1
                }
                if numberOfTypers == 1 {
                    names = "\(names) is typing"
                }
            }
            self.typingUserLbl.stringValue = names
        }
        
        if AuthService.instance.isLoggedIn == false {
            channelTitileLbl.stringValue = "Please Login"
            channelDescriptionLbl.stringValue = ""
            typingUserLbl.stringValue = ""
        }
        
        view.wantsLayer = true
        view.layer?.backgroundColor = CGColor.white
        
        messageOutlineView.wantsLayer = true
        messageOutlineView.layer?.backgroundColor = CGColor.white
        messageOutlineView.layer?.borderColor = NSColor.controlHighlightColor.cgColor
        messageOutlineView.layer?.borderWidth = 2
        messageOutlineView.layer?.cornerRadius = 5
        
        sendMessageBtn.styleButtonText(button: sendMessageBtn, buttonName: "Send", fontColor: .darkGray, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
        
        setTextField()
    }
    
    func setTextField(){
        if AuthService.instance.isLoggedIn {
            messageTxt.isEditable = true
        } else {
            messageTxt.isEditable = false
        }
    }
    
    func updateWithChannel(channel: Channel){
        typingUserLbl.stringValue = ""
        self.channel = channel
        let channelName = channel.channelTitle ?? ""
        let channelDesc = channel.channelDescription ?? ""
        
        channelDescriptionLbl.stringValue = channelDesc
        channelTitileLbl.stringValue = "#\(channelName)"
        getChats()
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        guard let channelId = channel?.id else { return }
        if messageTxt.stringValue == "" {
            isTyping = false
            SocketService.instance.socket.emit("stopType", user.name, channelId)
        } else {
            if isTyping == false {
                SocketService.instance.socket.emit("startType", user.name, channelId)
            }
            isTyping = true
        }
    }
    
    func getChats(){
        guard let channelId = self.channel?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success, msg) in
            if success {
                self.tableView.reloadData()
                let msgCount = MessageService.instance.messages.count
                if msgCount > 1 {
                    self.tableView.scrollRowToVisible(MessageService.instance.messages.count - 1)
                }
                
            } else {
                //TODO - Do something on error
            }
        }
    }
    @IBAction func sendMessageOnEnter(_ sender: Any) {
        sendMessageBtn.performClick(nil)
    }
    
    @IBAction func sendMessageButtonClicked(_ sender: Any) {
        print("send message clicked")
        guard let channelId = channel?.id else { return }
        
        if AuthService.instance.isLoggedIn {
            SocketService.instance.addMessage(messageBody: messageTxt.stringValue, userId: user.id, channelId: channelId, compleation: { (success) in
                if success {
                    self.messageTxt.stringValue = ""
                    SocketService.instance.socket.emit("stopType", self.user.name, channelId)
                }
            })
        } else {
            let modalDict = [USER_INFO_MODAL: ModalType.login]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: modalDict)
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn {
            if let channel = self.channel {
                channelTitileLbl.stringValue = channel.channelTitle
                channelDescriptionLbl.stringValue = channel.channelDescription
            } else {
                channelTitileLbl.stringValue = "Please select a channel"
            }
            
        } else {
            channelTitileLbl.stringValue = "Please Login"
            channelDescriptionLbl.stringValue = ""
            typingUserLbl.stringValue = ""
            tableView.reloadData()
        }
        setTextField()
    }
    
}

extension ChatVC: NSTableViewDelegate, NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "chatCell"), owner: nil) as? ChatCell {
            let chat = MessageService.instance.messages[row]
            cell.configureCell(chat: chat)
            return cell
        } else {
            return NSTableCellView()
        }
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100.0
    }
    
}


