//
//  ModalLogin.swift
//  SlackClone
//
//  Created by Joseph DuBay on 11/9/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class ModalLogin: NSView {

    // Outlets
    @IBOutlet weak var view : NSView!
    @IBOutlet weak var userNameTxt: NSTextField!
    @IBOutlet weak var passwordTxt: NSSecureTextField!
    @IBOutlet weak var emailLoginBtn: NSButton!
    @IBOutlet weak var createAccountBtn: NSButton!
    @IBOutlet weak var loginStackView: NSStackView!
    @IBOutlet weak var progressSpinner: NSProgressIndicator!
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ModalLogin"), owner: self, topLevelObjects: nil)
        
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
        
        emailLoginBtn.styleButtonText(button: emailLoginBtn, buttonName: "Login", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 14.0)
        emailLoginBtn.layer?.backgroundColor = chatGreen.cgColor
        emailLoginBtn.layer?.cornerRadius = 7
        
        createAccountBtn.styleButtonText(button: createAccountBtn, buttonName: "Create Account", fontColor: chatGreen, alignment: .center, font: AVENIR_REGULAR, size: 12.0)
        //createAccountBtn.layer?.backgroundColor = chatGreen.cgColor
        
        
    }
    
    func waitForLogin(loginIn: Bool){
        if loginIn {
            progressSpinner.isHidden = false
            progressSpinner.startAnimation(nil)
            loginStackView.alphaValue = 0.4
            emailLoginBtn.isEnabled = false
        } else {
            progressSpinner.isHidden = true
            progressSpinner.stopAnimation(nil)
            loginStackView.alphaValue = 1
            emailLoginBtn.isEnabled = true
        }
    }
    
    func loginUser(){
        if !( userNameTxt.stringValue.isEmpty || passwordTxt.stringValue.isEmpty) {
            waitForLogin(loginIn: true)
            AuthService.instance.loginUser(email: userNameTxt.stringValue.lowercased(), password: passwordTxt.stringValue) { (success) in
                if success {
                    AuthService.instance.findUserByEmail(completion: { (success) in
                        if success {
                            NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
                            NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        } else {
                            Swift.debugPrint("Find user failed")
                        }
                        self.waitForLogin(loginIn: false)
                    })
                } else {
                    Swift.debugPrint("Login failed")
                    self.waitForLogin(loginIn: false)
                }
            }
        } else {
            if userNameTxt.stringValue.isEmpty && passwordTxt.stringValue.isEmpty{
                debugPrint("No user name or password")
            }else if userNameTxt.stringValue.isEmpty{
                debugPrint("No user name")
            } else {
                debugPrint("No password")
            }
            
        }
    }
    
    @IBAction func closeModelClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    @IBAction func loginSentByEnterKey(_ sender: Any) {
        emailLoginBtn.performClick(nil)
    }
    
    @IBAction func emailLoginBtnClicked(_ sender: Any) {
        loginUser()
    }
    
    @IBAction func createAccountBtnClicked(_ sender: Any) {
        let closeImmediatelyDict: [String: Bool] = [USER_INFO_REMOVE_IMMEDIATELY: true]
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil, userInfo: closeImmediatelyDict)
        
        let createAccountDict: [String: ModalType] = [USER_INFO_MODAL: ModalType.createAccount]
        NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: createAccountDict)
    }
    
    
}
