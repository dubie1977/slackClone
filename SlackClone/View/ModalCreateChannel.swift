//
//  ModalCreateChannel.swift
//  SlackClone
//
//  Created by dubie on 11/29/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class ModalCreateChannel: NSView {

    // Outlets
    @IBOutlet weak var view : NSView!
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var channelNameTxt: NSTextField!
    @IBOutlet weak var channelDiscription: NSTextField!
    @IBOutlet weak var createChannelBtn: NSButton!
    @IBOutlet weak var errorMsgLbl: NSTextField!
    @IBOutlet weak var progressSpinner: NSProgressIndicator!
    
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ModalCreateChannel"), owner: self, topLevelObjects: nil)
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
        
        createChannelBtn.styleButtonText(button: createChannelBtn, buttonName: "Create Channel", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 14.0)
        createChannelBtn.layer?.backgroundColor = chatGreen.cgColor
        createChannelBtn.layer?.cornerRadius = 7
        
        errorMsgLbl.isHidden = true
    }
    
    func waitForAction(loginIn: Bool){
        if loginIn {
            progressSpinner.isHidden = false
            progressSpinner.startAnimation(nil)
            stackView.alphaValue = 0.4
            createChannelBtn.isEnabled = false
        } else {
            progressSpinner.isHidden = true
            progressSpinner.stopAnimation(nil)
            stackView.alphaValue = 1
            createChannelBtn.isEnabled = true
        }
    }
    
    func displayErrorMsg(msg: String){
        errorMsgLbl.stringValue = AuthService.instance.errorMsg
        errorMsgLbl.isHidden = false
    }
    @IBAction func closeModelClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    
    @IBAction func createChannelBtnClicked(_ sender: Any) {
    }
    
    @IBAction func createChannelSentByEnterKey(_ sender: Any) {
        createChannelBtn.performClick(nil)
    }
    
    
    
}
