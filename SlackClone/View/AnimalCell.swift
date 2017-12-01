//
//  AnimalCell.swift
//  SlackClone
//
//  Created by dubie on 11/30/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa

class AnimalCell: NSCollectionViewItem {

    @IBOutlet weak var animalImg: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        setupView()
    }
    
    func setupView(){
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        view.layer?.cornerRadius = 10
        view.layer?.borderWidth = 2
        view.layer?.borderColor = NSColor.darkGray.cgColor
    }
    
    func configureCell(index: Int, type: AnimalType){
        if type == AnimalType.dark {
            animalImg.image = NSImage(named: NSImage.Name(rawValue: "dark\(index)"))
            view.layer?.backgroundColor = NSColor.lightGray.cgColor
        } else {
            animalImg.image = NSImage(named: NSImage.Name(rawValue: "light\(index)"))
            view.layer?.backgroundColor = NSColor.gray.cgColor
        }
    }
    
}
