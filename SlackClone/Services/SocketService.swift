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
    
    func getChannel(completion: @escaping CompleationHandeler){
        socket.on("channelCreated") { (dataArray, socketAck) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            MessageService.instance.channels.append(newChannel)
            
            completion(true)
        }
    }
    
    func getMessages(_ completionHandler: @escaping (_ newMessage: Message) -> Void){
        socket.on("messageCreated") { (dataArray, socketAck) in
            guard let messageBody = dataArray[0] as? String else { return }
            guard let userId = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            let newMessage = Message(id: id, messageBody: messageBody, userId: userId, channelId: channelId, userName: userName, userAvatar: userAvatar, userAvatarColer: userAvatarColor, timeStamp: timeStamp)
            
            completionHandler(newMessage)
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
