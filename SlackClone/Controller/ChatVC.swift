//
//  ChatVC.swift
//  SlackClone
//
//  Created by dubie on 11/7/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class ChatVC: NSViewController {

    // Outlets
    @IBOutlet weak var channelTitileLbl: NSTextField!
    @IBOutlet weak var channelDescriptionLbl: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var typingUserLbl: NSTextField!
    @IBOutlet weak var messageOutlineView: NSView!
    @IBOutlet weak var messageTxt: NSTextField!
    @IBOutlet weak var sendMessageBtn: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear() {
        setupView()
    }
    
    func setupView(){
        view.wantsLayer = true
        view.layer?.backgroundColor = CGColor.white
        
        messageOutlineView.wantsLayer = true
        messageOutlineView.layer?.backgroundColor = CGColor.white
        messageOutlineView.layer?.borderColor = NSColor.controlHighlightColor.cgColor
        messageOutlineView.layer?.borderWidth = 2
        messageOutlineView.layer?.cornerRadius = 5
        
        sendMessageBtn.styleButtonText(button: sendMessageBtn, buttonName: "Send", fontColor: .darkGray, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
    }
    
    @IBAction func sendMessageButtonClicked(_ sender: Any) {
        print("send message clicked")
    }
    
    
}
