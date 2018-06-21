//
//  SplitView.swift
//  SlackClone
//
//  Created by dubie on 1/18/18.
//  Copyright © 2018 dubay. All rights reserved.
//

import Cocoa

class SplitView: NSSplitView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override var dividerThickness: CGFloat {
        get { return 0.0}
    }
    
}
