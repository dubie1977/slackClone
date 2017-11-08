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
        view.wantsLayer = true
        view.layer?.backgroundColor = chatPurple.cgColor
        
        addChannelBtn.styleButtonText(button: addChannelBtn, buttonName: "Add +", fontColor: .controlColor, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
    }
    
    @IBAction func addChannelButtonClicked(_ sender: Any) {
        print("add channel clicked")
    }
    
    
}
