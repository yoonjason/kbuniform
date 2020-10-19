//
//  ViewController.swift
//  kbuniform
//
//  Created by twave on 2020/08/31.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SwiftJWT
import WidgetKit

struct MyClaims: Claims {
    let iss: String
    let sub: String
    let exp: Date
    let admin: Bool
}


@available(iOS 14.0, *)
class ViewController: UIViewController {

    @IBOutlet weak var webviewBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var sideBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "KBO Uniform"
        webviewBtn
            .rx
            .tap
            .subscribe(onNext: {
                self.performSegue(withIdentifier: SegueIndentifier.MOVETOWEBVIEW.rawValue, sender: nil)
            })
            .disposed(by: rx.disposeBag)

        loginBtn
            .rx
            .tap
            .subscribe(onNext: {
                self.performSegue(withIdentifier: SegueIndentifier.MOVETOLOGINVIEW.rawValue, sender: nil)
            })
            .disposed(by: rx.disposeBag)

//        test()
        test2()

        sideBtn
            .rx
            .tap
            .subscribe(onNext: {
                self.performSegue(withIdentifier: "FromMainToSideMenu", sender: nil)
                print("Hey Side!")
            })
            .disposed(by: rx.disposeBag)


        setWidget()
    }

    @available(iOS 14.0, *)
    func setWidget() {
        WidgetCenter.shared.getCurrentConfigurations { (result) in
            switch (result) {
            case .success(let widgets):
                print(widgets)
                widgets.forEach {
                    print($0.family, $0.kind)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }

        }
    }

    func test2() {
        let myHeader = Header(kid: "KeyId1")
        let myClaims = MyClaims(iss: "yys", sub: "user", exp: Date(timeIntervalSince1970: 3600), admin: true)
        let privateKeyPath = Bundle.main.path(forResource: "privateKey", ofType: "key")!
        let privateeee = Bundle.main.path(forResource: "privateKey", ofType: "key", inDirectory: "Key")
//        print("privateeee", privateeee)

        let publicKeyPath = Bundle.main.path(forResource: "privateKey.key", ofType: "pub")!
//        print(publicKeyPath)
//        let privateKey = try! Data(contentsOf: URL(string: privateKeyPath!)!, options: .alwaysMapped)
        if let pubKeyURL = URL(string: publicKeyPath) {
            print("pubKeyURL :: ", pubKeyURL)
            do {

            }
        }

        guard let pubKeyUrl = URL(string: publicKeyPath) else {

            return
        }
        do {
            let pubKey = try Data(contentsOf: pubKeyUrl, options: .alwaysMapped)
            print(pubKey)
        } catch {
            print(error)
            print("key is null")
        }
//        WidgetCenter.shared.reloadTimelines(ofKind: <#T##String#>)


//        do {
//            let privateKey = try Data(contentsOf: URL(string: privateKeyPath)!, options: .alwaysMapped)
//
//            print(privateKey)
//        }catch {
//            print(error)
//        }
//        let publicKey = try! Data(contentsOf: URL(string: publicKeyPath!)!, options: .alwaysMapped)
//
//        print(privateKey, publicKey)
    }

    func test() {
        let myHeader = Header(kid: "KeyId1")
        let myClaims = MyClaims(iss: "yys", sub: "user", exp: Date(timeIntervalSince1970: 3600), admin: true)
        var myJWT = JWT(header: myHeader, claims: myClaims)
        // /Users/twave/Project/kbuniform/kbuniform/Key/
        let privateKeyPath = URL(fileURLWithPath: "/Users/twave/Project/privateKey.key")
        let privKey: Data = try! Data(contentsOf: privateKeyPath, options: .alwaysMapped)

        let pubKeyPath = URL(fileURLWithPath: "/Users/twave/Project/privateKey.key.pub")
        let pubKey: Data = try! Data(contentsOf: pubKeyPath, options: .alwaysMapped)

        let jwtSigner = JWTSigner.rs256(privateKey: privKey)

        do {
            let signedJWT = try myJWT.sign(using: jwtSigner)
            print(signedJWT)
        } catch {
            print(error)
        }




    }
}

/*
 file document 찾는거 였음;
 let filePath: String? = Bundle.main.path(forResource: "privateKey.key", ofType: "key")
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        print(#function, url)
        if let pathComponent = url.appendingPathComponent("privateKey.key") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
            } else {
                print("FILE NOT AVAILABLE")
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
 */
