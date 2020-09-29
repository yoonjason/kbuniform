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

struct User: Codable {
    var id: String?
    var nickname: String?
    var isConnected: Bool?
}

struct Message: Codable {
    var date: String?
    var message: String?
    var nickname: String?
}

class ChatListTestViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var userList = PublishSubject<[User]>()


    //ChatListTableViewCell
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.getUserList()
            SocketIOManager.shared.createGroupTalk()
        }
        
        userList
            .bind(to: tableView.rx.items(cellIdentifier: "ChatListTableViewCell", cellType: ChatListTableViewCell.self)) { (index, item, cell) in
                cell.userLabel.text = item.nickname
                cell.selectionStyle = .none
            }
            .disposed(by: rx.disposeBag)

        tableView
            .rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)

        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(User.self))
            .subscribe(onNext: { [self] (indexPath, item) in
                print(indexPath, item.id)
                if let goalUserId = item.id {
                    print(item.id)
                    self.performSegue(withIdentifier: SegueIndentifier.MOVETOMESSAGE.rawValue, sender: goalUserId)
//                    SocketIOManager.shared.sendSingleMessage(id: goalUserId, roomName: "useRoom")
                }
                
            })
            .disposed(by: rx.disposeBag)

    }

    func getUserList() {
//        let nickname = "jason\(Int.random(in: 0..<92939))"
        let nickname = "World"
        var userId = ""
        SocketIOManager.shared.connectToServerWithNickname(nickname: nickname, completionHandler: { (userList) in
            Globals.shared.setUserDefaults(withValue: nickname, key: "myname")
            print("\(#function)", userList)
            print("userId : \(userList?.first?.id)")
            if let socketUserId = userList?.first?.id {
                if let getUserId = Globals.shared.getUserDefaults(key: "userId") as? String {
                    if getUserId.isEmpty {
                        Globals.shared.setUserDefaults(withValue: socketUserId, key: "userId")
                    }else {
                        userId = getUserId
                    }
                }else {
                    Globals.shared.setUserDefaults(withValue: socketUserId, key: "userId")
                    if let getUserId = Globals.shared.getUserDefaults(key: "userId") as? String {
                        userId = getUserId
                    }
                }
            }
            

            if let users = userList {
                self.userList.onNext(users)
            }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIndentifier.MOVETOMESSAGE.rawValue {
            if let destinationVC = segue.destination as? MessageTestViewController {
                if let userId = sender as? String {
                    destinationVC.toId = userId
                    print("userId :: ",userId)
                }
            }
        }
    }
}

extension ChatListTestViewController: UIScrollViewDelegate {

}
