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
    let message = MessageService.instance
    
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
    
    func addChannel(channelName: String, channelDescription: String, compleation: @escaping CompleationHandelerWithMsg){
        
        if !doseChannelExist(channelName: channelName){
            socket.emit("newChannel", channelName, channelDescription)
            compleation(true, "")
        } else {
            compleation(false, "Channel alread exists")
        }
    }
    
    func doseChannelExist(channelName: String)-> Bool{

        for channel in message.channels{
            if channelName.lowercased() == channel.channelTitle.lowercased(){
                return true
            }
        }
        return false
    }
}
