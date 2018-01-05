//
//  MessageService.swift
//  SlackClone
//
//  Created by dubie on 12/7/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService{
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var unReadChannels = [String]()
    
    func findAllChannels(compleation: @escaping CompleationHandelerWithMsg){
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                if response.response!.statusCode / 100 == 2 {
                    guard let data = response.data else {return}
                    do{
                        self.clearChannels()
                        if let json = try JSON(data: data).array {
                            for item in json {
                                let name = item["name"].stringValue
                                let channelDescription = item["description"].stringValue
                                let id = item["_id"].stringValue
                                let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                                self.channels.append(channel)
                            }
                            compleation(true, "")
                        }
                    } catch{
                        debugPrint(error)
                        compleation(false, error.localizedDescription)
                        return
                    }
                }else {
                    guard let data = response.data else { return }
                    let error = self.setErrorMsg(data: data)
                    compleation(false, error)
                    debugPrint(response.result.error as Any)
                }
            }
        }
    }
    
    func findAllMessagesForChannel(channelId: String, compleation: @escaping CompleationHandelerWithMsg){
        
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                if response.response!.statusCode / 100 == 2 {
                    guard let data = response.data else {return}
                    do{
                        self.clearMessages()
                        if let json = try JSON(data: data).array{
                            for item in json {
                                let id = item["_id"].stringValue
                                let messageBody = item["messageBody"].stringValue
                                let userId = item["userId"].stringValue
                                let channelId = item["channelId"].stringValue
                                let userName = item["userName"].stringValue
                                let userAvatar = item["userAvatar"].stringValue
                                let userAvatarColor = item["userAvatarColor"].stringValue
                                let timeStamp = item["timeStamp"].stringValue
                                let message = Message(id: id, messageBody: messageBody, userId: userId, channelId: channelId, userName: userName, userAvatar: userAvatar, userAvatarColer: userAvatarColor, timeStamp: timeStamp)
                                self.messages.append(message)
                            }
                            compleation(true, "")
                        }
                    } catch{
                        debugPrint(error)
                        compleation(false, error.localizedDescription)
                        return
                    }
                } else {
                    print(response.response!.statusCode)
                }
            }
        }
    
    }
    
    func clearChannels(){
        channels.removeAll()
    }
    
    func clearMessages(){
        messages.removeAll()
    }
    
    func setErrorMsg(data: Data) -> String{
        do{
            let json = try JSON(data: data)
            let errorMsg = json["message"].stringValue
            return errorMsg
        } catch {
            return error.localizedDescription
        }
    }
}
