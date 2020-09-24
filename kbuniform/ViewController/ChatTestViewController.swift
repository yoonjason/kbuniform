//
//  ChatTestViewController.swift
//  kbuniform
//
//  Created by twave on 2020/09/23.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import SocketIO
import RxSwift
import RxCocoa
import NSObject_Rx

struct chatType {
    
}

class ChatTestViewController: UIViewController {

    var socket: SocketIOClient!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var disconnectBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        sendBtn
            .rx
            .tap
            .subscribe(onNext: {
                print("send")
//                SocketIOManager.shared.sendMessage(message: self.textField.text!, nickName: "yys")
                SocketIOManager.shared.sendToMessage(message: self.textField.text!, nickName: "윤영석")
//                SocketIOManager.shared.readMessage()
            })
            .disposed(by: rx.disposeBag)

        connectBtn
            .rx
            .tap
            .subscribe(onNext: {
                print("connectBtn")
                self.performSegue(withIdentifier: SegueIndentifier.MOVETOTESTCHAT.rawValue, sender: nil)
                SocketIOManager.shared.establishConnection()
                SocketIOManager.shared.connectToServerWithNickname(nickname: "Jason", completionHandler: { _ in
                  
                })
            })
            .disposed(by: rx.disposeBag)

        disconnectBtn
            .rx
            .tap
            .subscribe(onNext: {
                SocketIOManager.shared.closeconnection()
                print("disconnectBtn")
            })
            .disposed(by: rx.disposeBag)


        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
