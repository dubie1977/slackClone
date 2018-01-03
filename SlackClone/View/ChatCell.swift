//
//  ChatCell.swift
//  SlackClone
//
//  Created by Joseph DuBay on 1/1/18.
//  Copyright © 2018 dubay. All rights reserved.
//

import Cocoa

class ChatCell: NSTableCellView {

    @IBOutlet weak var profileImg: NSImageView!
    @IBOutlet weak var userNameLbl: NSTextField!
    @IBOutlet weak var timeStampLbl: NSTextField!
    @IBOutlet weak var messageBodyLbl: NSTextField!
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        profileImg.layer?.cornerRadius = 6
        profileImg.layer?.borderColor = NSColor.gray.cgColor
        profileImg.layer?.borderWidth = 2
    }
    
    func configureCell(chat: Message){
        messageBodyLbl.stringValue = chat.messageBody
        userNameLbl.stringValue = chat.userName
        profileImg.wantsLayer = true
        profileImg.image = NSImage(named: NSImage.Name(rawValue: chat.userAvatar!))
        profileImg.layer?.backgroundColor = UserDataService.instance.returnCGColor(components: chat.userAvatarColer)
        
        guard let isoDateFull = chat.timeStamp else { return }
        let end = isoDateFull.index(isoDateFull.endIndex, offsetBy: -6)
        let isoDate = isoDateFull[...end].appending("Z")
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate)
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate{
            let finalDate = newFormatter.string(from: finalDate)
            timeStampLbl.stringValue = finalDate
        }
    }
    
}
