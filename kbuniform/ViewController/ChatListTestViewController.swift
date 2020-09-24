//
//  ChatListTestViewController.swift
//  kbuniform
//
//  Created by twave on 2020/09/24.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import SocketIO

struct User : Codable {
    var id : String?
    var nickname : String?
    var isConnected : Bool?
}

class ChatListTestViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserList()
    }
    
    func getUserList(){
        SocketIOManager.shared.connectToServerWithNickname(nickname: "jason", completionHandler: { (userList)  in
            print("\(#function)" ,userList)
        })
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
