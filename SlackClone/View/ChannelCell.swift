//
//  ChannelCell.swift
//  SlackClone
//
//  Created by dubie on 12/8/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class ChannelCell: NSTableCellView {

    @IBOutlet weak var channelName: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

    }
    
    func configureCell(channel: Channel, isSelected: Bool){
        let title = channel.channelTitle ?? ""
        channelName.stringValue = "#\(title)"
        channelName.font = NSFont(name: AVENIR_REGULAR, size: 13.0)
        
        if MessageService.instance.unReadChannels.index(of: channel.id) != nil {
            channelName.font = NSFont(name: AVENIR_BOLD, size: 13.0)
        } else {
            channelName.font = NSFont(name: AVENIR_REGULAR, size: 13.0)
        }
        
        wantsLayer = true
        if isSelected{
            layer?.backgroundColor = chatGreen.cgColor
            channelName.textColor = NSColor.white
        }else{
            layer?.backgroundColor = CGColor.clear
            channelName.textColor = NSColor.controlColor
        }
        
    }
    
}
