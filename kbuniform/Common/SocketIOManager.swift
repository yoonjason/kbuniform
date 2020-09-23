//
//  SocketIOManager.swift
//  kbuniform
//
//  Created by twave on 2020/09/23.
//  Copyright © 2020 seokyu. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager : NSObject {
    
    static let shared = SocketIOManager()
    let urlString = ""
    var manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    override init() {
        super.init()
        socket = self.manager.socket(forNamespace: "/test")
        socket.on("test") { (dataArray, ack) in
            print(dataArray)
        }
    }
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeconnection() {
        socket.disconnect()
    }
    
    func sendMessage(message : String, nickName : String) {
        socket.emit("event", ["message" : "This is a test message"])
        socket.emit("event1", [["name":"yys"],["email" : "@naver.com"]])
        socket.emit("event2", ["name":"yys", "message" : "@gmail.com"])
        socket.emit("msg", ["nick":nickName, "msg" :message])
    }
    
    
    
    
    
}

