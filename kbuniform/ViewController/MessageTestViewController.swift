//
//  MessageTestViewController.swift
//  kbuniform
//
//  Created by twave on 2020/09/24.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx

class MessageTestViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!

//    var chatMessages = PublishSubject<[Message]>()
    var toId = ""
    var chatMessages = BehaviorRelay<[Message]>(value: [])
    var chatMessages2 = PublishSubject<[Message]>()
    var myname = Globals.shared.getUserDefaults(key: "myname")

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.cornerRadius = textView.frame.height / 2
        textView.layer.borderWidth = 1.0

        sendBtn
            .rx
            .tap
            .subscribe(onNext: { [self] in
                if let myname = Globals.shared.getUserDefaults(key: "myname") as? String {
                    SocketIOManager.shared.sendToMessage(message: self.textView.text, nickName: myname)
//                    SocketIOManager.shared.sendChatMessage(roomname: "test", message: self.textView.text, nickname: myname)
                }

//                SocketIOManager.shared.sendMessage(message: self.textView.text, toId: toId)
                self.textView.text = ""
            })
            .disposed(by: rx.disposeBag)

        SocketIOManager.shared.getChatMessage { [self] (message) in
            self.chatMessages.accept(self.chatMessages.value + [message])
            self.tableView.reloadData()
        }

//        chatMessages.bind(to: tableView.rx.items(cellIdentifier: "MyMessageViewCell", cellType: MyMessageViewCell.self)) { (index, item, cell) in
//            cell.messageLabel.text = item.message
//        }
//            .disposed(by: rx.disposeBag)

        chatMessages
            .bind(to: tableView.rx.items) { (tv, row, item) -> UITableViewCell in
                if item.nickname != self.myname as! String {
                    let cell = tv.dequeueReusableCell(withIdentifier: "OtherMessageViewCell", for: IndexPath.init(row: row, section: 0)) as! OtherMessageViewCell
                    cell.nicknameLabel.text = item.nickname
                    cell.messageLabel.text = item.message
                    return cell
                }else {
                    let cell = tv.dequeueReusableCell(withIdentifier: "MyMessageViewCell", for: IndexPath.init(row: row, section: 0)) as! MyMessageViewCell
                    
                    cell.messageLabel.text = item.message
                    return cell
                }
            }
            .disposed(by: rx.disposeBag)

//        NotificationCenter
//            .default
//            .addObserver(self, selector: "handleConnectedUserUpdateNotification", name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
//
//        NotificationCenter.default
//            .addObserver(self, selector: "handleDisconnectedUserUpdateNotification", name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)


        // Do any additional setup after loading the view.
    }


    func handleConnectedUserUpdateNotification(notification: Notification) {

    }

    func handleDisconnectedUserUpdateNotification(notification: Notification) {

    }
}
