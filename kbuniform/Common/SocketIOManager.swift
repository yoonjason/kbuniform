//
//  SocketIOManager.swift
//  kbuniform
//
//  Created by twave on 2020/09/23.
//  Copyright © 2020 seokyu. All rights reserved.
//

import Foundation
import SocketIO
import RxSwift
//MARK: - 참고할 것
/*
 https://www.google.com/search?newwindow=1&sxsrf=ALeKk03WFWjoWuyLZHAKVsAhHCGvkVx4gA:1601338797424&q=socket.io+room+list&sa=X&ved=2ahUKEwiCzr3xi43sAhXsKqYKHcLIAP84ChDVAigDegQICxAE&biw=2106&bih=1297
 https://gipyeonglee.tistory.com/99
 https://opens.kr/63
 
 */
struct ChatType {
    var type = -1
    var message = ""
}
//emit : 보내고?, on : 받고!

class SocketIOManager: NSObject {

    static let shared = SocketIOManager()
    let urlString = ""
    var manager = SocketManager(socketURL: URL(string: "http://localhost:9000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!

    override init() {
        super.init()
        socket = self.manager.socket(forNamespace: "/")
//        print(#function, ":::::::::::: init")
    }

    func establishConnection() {
        socket.connect()
        print(#function, ":::::::::::: establishConnection")
    }

    func closeconnection() {
        socket.disconnect()
    }

    func getchatList(name: String) {
        socket = self.manager.socket(forNamespace: "/getChatList/room")
        establishConnection()
    }


    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [User]?) -> Void) {
        socket.emit("connectUser", nickname)

        socket.on("userList") { [weak self] (result, ack) -> Void in
            print("result ::::: ", result)
            guard result.count > 0,
                let _ = self,
                let user = result.first as? [[String: Any]],
                let data = UIApplication.jsonData(from: user) else {
                    return
            }
            do {
                let userModel = try JSONDecoder().decode([User].self, from: data)
                completionHandler(userModel)

                print("userModel :: ", userModel)
            }
            catch let error {
                print("Something happen wrong here...\(error)")
                completionHandler(nil)
            }
        }
        listenForOtherMessages()
    }

    func exitChatWithNickname(nickname: String, completionHandler: @escaping () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }

    func sendToMessage(message: String, nickName: String) {
        socket.emit("chatMessage", ["message": message, "nickname": nickName])
    }

    func sendMessage(message: String, toId: String) {
        socket.emit("toMessage", ["message": message, "toId": toId])
    }

    func getMessage(completionHandler: @escaping (_ messageInfo: Message) -> Void) {
        socket.on("sendServerToMessage") { (dataArray, ack) in
            print(dataArray)
            print("dataArray :: ", dataArray)
            var messageInfo = [String: Any]()

            guard let messageData = dataArray[0] as? NSMutableDictionary,
                let date = dataArray[1] as? String else {
                    return
            }

            messageInfo["date"] = date
            messageInfo["message"] = messageData["message"]
            messageInfo["nickname"] = messageData["nickname"]

            print("messageInfo", messageInfo)
            guard let data = UIApplication.jsonData(from: messageInfo) else {
                return
            }

            print("data ||", data)
            do {
                let message = try JSONDecoder().decode(Message.self, from: data)
                completionHandler(message)

                print("sendMessage!!!!! :: ", message)
            } catch let error {
                print(error)
            }
        }
    }

    func getChatMessage(completionHandler: @escaping (_ mseeageInfo: Message) -> Void) {
        socket.on("newChatMessage") { (dataArray, ack) in
            print("dataArray :: ", dataArray)
            var messageInfo = [String: Any]()

            guard let messageData = dataArray[0] as? NSMutableDictionary,
                let date = dataArray[1] as? String else {
                    return
            }

            messageInfo["date"] = date
            messageInfo["message"] = messageData["message"]
            messageInfo["nickname"] = messageData["nickname"]

            print("messageInfo", messageInfo)
            guard let data = UIApplication.jsonData(from: messageInfo) else {
                return
            }

            print("data ||", data)
            do {
                let message = try JSONDecoder().decode(Message.self, from: data)
                completionHandler(message)

                print("sendMessage!!!!! :: ", message)
            } catch let error {
                print(error)
            }
        }
    }

    func sendSingleMessage(id: String, roomName: String) {
        socket.emit("singleChat", ["id": id, "roomname": roomName])
    }

    func sendChatMessage(roomname: String, message: String, nickname: String) {
        socket.emit("groupMessage", ["roomname": roomname, "message": message, "nickname": nickname])
        print(#function)
    }

    func readMessage() {
        socket.on("ff") { (dataArray, socketAck) in
            print(#function)
            var chat = ChatType()

            print(type(of: dataArray))
            let data = dataArray[0] as! NSDictionary

            chat.type = data["type"] as! Int
            chat.message = data["message"] as! String

            print(chat.type, chat.message)
        }
    }

    private func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, ack) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
        socket.on("userExitUpdate") { (dataArray, ack) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
    }

//    func connectToServerWithNickname(nickname : String, completionHandler: @escaping (_ userList : [User]) -> Void) {
//
//    }
//

    func createGroupTalk() {
        print(":::::: \(#function)")
        socket.emit("createRoom", ["roomname": "test"])
    }

}

