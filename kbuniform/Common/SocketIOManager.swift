//
//  SocketIOManager.swift
//  kbuniform
//
//  Created by twave on 2020/09/23.
//  Copyright © 2020 seokyu. All rights reserved.
//

import Foundation
import SocketIO

struct ChatType {
    var type = -1
    var message = ""
}
//emit : 보내고?, on : 

class SocketIOManager : NSObject {
    
    static let shared = SocketIOManager()
    let urlString = ""
    var manager = SocketManager(socketURL: URL(string: "http://localhost:9000")!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    override init() {
        super.init()
        socket = self.manager.socket(forNamespace: "/")
    }
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeconnection() {
        socket.disconnect()
    }
    
    func connectToServerWithNickname(nickname : String, completionHandler : (_ userList : [[String : AnyObject]]?) -> Void) {
        socket.emit("connectUser", nickname)
    }
    
    func sendMessage(message : String, nickName : String) {
        socket.emit("event", ["message" : "This is a test message"])
        socket.emit("event1", [["name":"yys"],["email" : "@naver.com"]])
        socket.emit("event2", ["name":"yys", "message" : "@gmail.com"])
        socket.emit("msg", ["nick":nickName, "msg" :message])
    }
    
    func sendToMessage(message : String, nickName : String) {
        socket.emit("eventString", ["message" : message, "nickname" : nickName])
    }
    
    func readMessage() {
        socket.on("ff"){ (dataArray, socketAck) in
            print(#function)
            var chat = ChatType()
            
            print(type(of: dataArray))
            let data = dataArray[0] as! NSDictionary
            
            chat.type = data["type"] as! Int
            chat.message = data["message"] as! String
            
            print(chat.type, chat.message)
        }
    }
    
    
    
}

