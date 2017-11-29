//
//  AuthService.swift
//  SlackClone
//
//  Created by dubie on 11/13/17.
//  Copyright © 2017 dubay. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService{
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            let isLogged = defaults.bool(forKey: LOGGED_IN_KEY)
            return isLogged
        } set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        } set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        } set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    var errorMsg: String{
        get {
            return defaults.value(forKey: ERROR_MSG) as! String
        } set {
            defaults.set(newValue, forKey: ERROR_MSG)
        }
    }
    
    
    func registerUser(email: String, password: String, completion: @escaping CompleationHandeler) {
        
        let lowerCaseEmail = email.lowercased()

        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString{
            (response) in
            if response.result.error == nil {
                if response.response!.statusCode / 100 == 2{
                    self.errorMsg = ""
                    completion(true)
                } else {
                    guard let data = response.data else { return }
                    self.setErrorMsg(data: data)
                    self.isLoggedIn = false
                    completion(false)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompleationHandeler){
        
        let lowerCaseEmail = email.lowercased()

        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil{
                if response.response!.statusCode / 100 == 2 {
                    guard let data = response.data else { return }
                    do{
                        let json = try JSON(data: data)
                        self.userEmail =  json["user"].stringValue
                        self.authToken =  json["token"].stringValue
                        self.isLoggedIn = true
                        self.errorMsg = ""
                        completion(true)
                    } catch {
                        debugPrint(error)
                        return
                    }
                } else {
                    guard let data = response.data else { return }
                    self.setErrorMsg(data: data)
                    self.isLoggedIn = false
                    completion(false)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
                
            }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompleationHandeler) {
        
        let lowerCaseEmail = email.lowercased()
        
        
        
        let body: [String: Any] = [
            "name" : name,
            "email": lowerCaseEmail,
            "avatarName" : avatarName,
            "avatarColor" : avatarColor
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil{
                if response.response!.statusCode / 100 == 2 {
                    guard let data = response.data else {return }
                    self.setUserInfo(data: data)
                    self.errorMsg = ""
                    completion(true)
                }else {
                    guard let data = response.data else { return }
                    self.setErrorMsg(data: data)
                    self.isLoggedIn = false
                    completion(false)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func findUserByEmail(completion: @escaping CompleationHandeler){
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                if response.response!.statusCode / 100 == 2 {
                    guard let data = response.data else {return}
                    self.setUserInfo(data: data)
                    self.errorMsg = ""
                    completion(true)
                }else {
                    guard let data = response.data else { return }
                    self.setErrorMsg(data: data)
                    self.isLoggedIn = false
                    completion(false)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func setErrorMsg(data: Data){
        do{
            let json = try JSON(data: data)
            self.errorMsg = json["message"].stringValue
            self.isLoggedIn = false
            debugPrint("ErrorMsg: \(self.errorMsg)")
        } catch {
            debugPrint(error)
        }
    }
    
    func setUserInfo(data: Data){
        do{
            let json = try JSON(data: data)
            UserDataService.instance.id = json["_id"].stringValue
            UserDataService.instance.avatarColor = json["avatarColor"].stringValue
            UserDataService.instance.avatarName = json["avatarName"].stringValue
            UserDataService.instance.email = json["email"].stringValue
            UserDataService.instance.name = json["name"].stringValue
        } catch {
            debugPrint(error)
            return
        }
    }
    
    
}
