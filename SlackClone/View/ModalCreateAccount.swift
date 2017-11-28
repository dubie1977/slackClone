//
//  modalCreateAccount.swift
//  SlackClone
//
//  Created by Joseph DuBay on 11/9/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class ModalCreateAccount: NSView {

    // Outlets
    @IBOutlet weak var view : NSView!
    @IBOutlet weak var nameTxt: NSTextField!
    @IBOutlet weak var emailTxt: NSTextField!
    @IBOutlet weak var passwordTxt: NSSecureTextField!
    @IBOutlet weak var profileImg: NSImageView!
    @IBOutlet weak var chooseImageBtn: NSButton!
    @IBOutlet weak var createAccountBtn: NSButton!
    @IBOutlet weak var progressSpinner: NSProgressIndicator!
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var errorMsgLbl: NSTextField!
    
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ModalCreateAccount"), owner: self, topLevelObjects: nil)
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
        
        createAccountBtn.styleButtonText(button: createAccountBtn, buttonName: "Create Account", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
        createAccountBtn.layer?.backgroundColor = chatGreen.cgColor
        createAccountBtn.layer?.cornerRadius = 7
        chooseImageBtn.styleButtonText(button: chooseImageBtn, buttonName: "Choose Avatar", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
        chooseImageBtn.layer?.backgroundColor = chatGreen.cgColor
        chooseImageBtn.layer?.cornerRadius = 7
        
        nameTxt.focusRingType = .none
        passwordTxt.focusRingType = .none
        emailTxt.focusRingType = .none
        
        errorMsgLbl.isHidden = true
    }
    
    func waitForLogin(loginIn: Bool){
        if loginIn {
            progressSpinner.isHidden = false
            progressSpinner.startAnimation(nil)
            stackView.alphaValue = 0.4
            createAccountBtn.isEnabled = false
        } else {
            progressSpinner.isHidden = true
            progressSpinner.stopAnimation(nil)
            stackView.alphaValue = 1
            createAccountBtn.isEnabled = true
        }
    }
    
    func displayErrorMsg(msg: String){
        errorMsgLbl.stringValue = AuthService.instance.errorMsg
        errorMsgLbl.isHidden = false
    }
    
    @IBAction func closeModalClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    @IBAction func createAccountClicked(_ sender: Any) {
        waitForLogin(loginIn: true)
        AuthService.instance.registerUser(email: emailTxt.stringValue, password: passwordTxt.stringValue) { (success) in
            if success {
                AuthService.instance.loginUser(email: self.emailTxt.stringValue, password: self.passwordTxt.stringValue, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: self.nameTxt.stringValue, email: self.emailTxt.stringValue, avatarName: "dark5", avatarColor: "", completion: { (success) in
                            self.waitForLogin(loginIn: false)
                            NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
                        })
                    } else {
                        debugPrint("Login user Failed")
                        self.displayErrorMsg(msg: AuthService.instance.errorMsg)
                        self.waitForLogin(loginIn: false)
                    }
                })
            } else {
                self.displayErrorMsg(msg: AuthService.instance.errorMsg)
                self.waitForLogin(loginIn: false)
            }
        }
    }
    
    @IBAction func chooseImageClicked(_ sender: Any) {
    }
    
    
}
