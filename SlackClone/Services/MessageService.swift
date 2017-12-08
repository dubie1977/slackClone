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
    
    func findAllChannels(compleation: @escaping CompleationHandeler){
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                if response.response!.statusCode / 100 == 2 {
                    guard let data = response.data else {return}
                    do{
                        if let json = try JSON(data: data).array {
                            for item in json {
                                let name = item["name"].stringValue
                                let channelDescription = item["description"].stringValue
                                let id = item["_id"].stringValue
                                let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                                self.channels.append(channel)
                            }
                            compleation(true)
                        }
                    } catch{
                        debugPrint(error)
                        compleation(false)
                        return
                    }
                }else {
                    guard let data = response.data else { return }
                    self.setErrorMsg(data: data)
                    compleation(false)
                    debugPrint(response.result.error as Any)
                }
            }
        }
    }
    
    func setErrorMsg(data: Data){
        do{
            let json = try JSON(data: data)
            var errorMsg = json["message"].stringValue
            //TODO: Need to do something with the error msg
            debugPrint("ErrorMsg: \(errorMsg)")
        } catch {
            debugPrint(error)
        }
    }
}
