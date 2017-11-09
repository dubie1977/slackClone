//
//  ClickBlockingView.swift
//  SlackClone
//
//  Created by Joseph DuBay on 11/9/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class ClickBlockingView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        
        
        
    }
    
    // Disables mouse on this view
    override func mouseDown(with event: NSEvent){}
    override func mouseUp(with: NSEvent){}
    override func mouseDragged(with: NSEvent){}
    override func mouseMoved(with: NSEvent){}
    
}
