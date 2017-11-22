//
//  ModalProfile.swift
//  SlackClone
//
//  Created by dubie on 11/22/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class ModalProfile: NSView {

    // Outlets
    @IBOutlet weak var view : NSView!
    @IBOutlet weak var userNameTxt: NSTextField!
    @IBOutlet weak var emailTxt: NSTextField!
    @IBOutlet weak var profileImg: NSImageView!
    @IBOutlet weak var logoutBtn: NSButton!
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ModalProfile"), owner: self, topLevelObjects: nil)
        self.addSubview(self.view)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        setupView()
    }
    
    func setupView(){
        self.view.frame = NSRect(x: 0, y: 0, width: 475, height: 300)
        view.layer?.backgroundColor = CGColor.white
        view.layer?.cornerRadius = 7
        
        profileImg.layer?.cornerRadius = 10
        profileImg.layer?.borderColor = NSColor.gray.cgColor
        profileImg.layer?.borderWidth = 3
        profileImg.image = NSImage(named: NSImage.Name(rawValue: UserDataService.instance.avatarName))
        //TODO: profile background color
        
        logoutBtn.layer?.backgroundColor = chatGreen.cgColor
        logoutBtn.layer?.cornerRadius = 7
        logoutBtn.styleButtonText(button: logoutBtn, buttonName: "Logout", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
        
        userNameTxt.stringValue = UserDataService.instance.name
        emailTxt.stringValue = UserDataService.instance.email
        
    }
    
    @IBAction func closeModalClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
    }
    
    
    
}
