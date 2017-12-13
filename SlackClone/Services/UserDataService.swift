//
//  UserDataService.swift
//  SlackClone
//
//  Created by dubie on 11/16/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Foundation


class UserDataService {
    static let instance = UserDataService()
    
    fileprivate var _id = ""
    fileprivate var _avatarColor = ""
    fileprivate var _avatarName = ""
    fileprivate var _email = ""
    fileprivate var _name = ""
    
    var id: String {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var avatarColor: String {
        get {
            return _avatarColor
        }
        set {
            _avatarColor = newValue
        }
    }
    
    var avatarColorCG: CGColor {
        get{
            return returnCGColor(components: _avatarColor)
        }
    }
    
    var avatarName: String {
        get{
            return _avatarName
        }
        set {
            _avatarName = newValue
        }
    }
    
    var email: String {
        get{
            return _email
        }
        set {
            _email = newValue
        }
    }
    
    var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    
    func returnCGColor(components: String) -> CGColor {
        //[0.465327603549635, 1.0, 0.331889263765667, 1.0]
        
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = CGColor(red: 0.69, green: 0.85, blue: 0.99, alpha: 1.0)
        guard let rUnwrapped = r else { return defaultColor}
        guard let gUnwrapped = g else { return defaultColor}
        guard let bUnwrapped = b else { return defaultColor}
        guard let aUnwrapped = a else { return defaultColor}
        
        let rfloat = CGFloat(rUnwrapped.doubleValue)
        let gfloat = CGFloat(gUnwrapped.doubleValue)
        let bfloat = CGFloat(bUnwrapped.doubleValue)
        let afloat = CGFloat(aUnwrapped.doubleValue)
        
        let newCGColor = CGColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        return newCGColor
    }
    
    func logOutUser(){
        _id = ""
        _avatarName = ""
        _avatarColor = ""
        _email = ""
        _name = ""
        AuthService.instance.authToken = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        MessageService.instance.channels = [Channel]()
    }
}
