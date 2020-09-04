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

class ViewController: UIViewController {

    @IBOutlet weak var webviewBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "KBO Uniform"
        webviewBtn
            .rx
            .tap
            .subscribe(onNext : {
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
    }
}

