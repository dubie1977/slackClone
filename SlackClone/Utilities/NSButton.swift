//
//  NSButton.swift
//  weathered
//
//  Created by dubie on 8/18/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

extension NSButton{
    func styleButtonText(button: NSButton, buttonName: String, fontColor: NSColor, alignment: NSTextAlignment, font: String, size: CGFloat){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        button.attributedTitle = NSAttributedString(string: buttonName, attributes: [NSAttributedStringKey.foregroundColor: fontColor, NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.font: NSFont(name: font, size: size)!])
    }
}
