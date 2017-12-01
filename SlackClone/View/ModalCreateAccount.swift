//
//  modalCreateAccount.swift
//  SlackClone
//
//  Created by Joseph DuBay on 11/9/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class ModalCreateAccount: NSView, NSPopoverDelegate {

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
    @IBOutlet weak var colorPicker: NSColorWell!
    
    // Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    let popover = NSPopover()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        popover.delegate = self
        
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
        //profileImg.layer?.backgroundColor = CGColor(name: "")
        
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
    
    func popoverDidClose(_ notification: Notification) {
        if UserDataService.instance.avatarName != ""{
            profileImg.image = NSImage(named: NSImage.Name(rawValue: UserDataService.instance.avatarName))
            avatarName = UserDataService.instance.avatarName
        }
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
        errorMsgLbl.stringValue = msg
        errorMsgLbl.isHidden = false
    }
    
    func checkRequiredFields()->Bool{
        var isRequirementMet = false
        if ( emailTxt.stringValue.isEmpty || passwordTxt.stringValue.isEmpty) {
            if emailTxt.stringValue.isEmpty && passwordTxt.stringValue.isEmpty{
                displayErrorMsg(msg: "Please enter an email and password")
            }else if emailTxt.stringValue.isEmpty{
                displayErrorMsg(msg: "Please enter an email")
            } else {
                displayErrorMsg(msg: "Please enter a password")
            }
        } else {
            isRequirementMet = true
            errorMsgLbl.stringValue = ""
            errorMsgLbl.isHidden = true
        }
        
        return isRequirementMet
    }
    
    @IBAction func closeModalClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    @IBAction func createAccountClicked(_ sender: Any) {
        if checkRequiredFields() {
            waitForLogin(loginIn: true)
            AuthService.instance.registerUser(email: emailTxt.stringValue, password: passwordTxt.stringValue) { (success) in
                if success {
                    AuthService.instance.loginUser(email: self.emailTxt.stringValue, password: self.passwordTxt.stringValue, completion: { (success) in
                        if success {
                            AuthService.instance.createUser(name: self.nameTxt.stringValue, email: self.emailTxt.stringValue, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
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
    }
    
    @IBAction func chooseImageClicked(_ sender: Any) {
        popover.contentViewController = AvatarPickerVC(nibName: NSNib.Name(rawValue: "AvatarPickerVC"), bundle: nil)
        popover.show(relativeTo: chooseImageBtn.bounds, of: chooseImageBtn, preferredEdge: .minX)
        popover.behavior = .transient
    }
    
    @IBAction func chooseColor(_ sender: Any) {
        profileImg.layer?.backgroundColor = colorPicker.color.cgColor
        let color = colorPicker.color.cgColor
        guard let colorArray = color.components?.description else { return }
        avatarColor = colorArray
        debugPrint(colorArray)
    }
    
    
}
