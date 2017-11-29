//
//  SocketService.swift
//  SlackClone
//
//  Created by dubie on 11/28/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Cocoa
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    let socket: SocketIOClient = SocketIOClient(socketURL: URL(string:BASE_URL)!)
    let user = UserDataService.instance
    
    override init(){
        super.init()
    }
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, compleation: @escaping CompleationHandeler){
        
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        compleation(true)
    }
}
