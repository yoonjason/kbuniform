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


class ViewController: UIViewController {

    @IBOutlet weak var webviewBtn: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "KBO Uniform"
        webviewBtn
            .rx
            .tap
            .subscribe(onNext : {
                self.performSegue(withIdentifier: SegueIndentifier.MOVETOWEBVIEW.rawValue, sender: nil)
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }


}

