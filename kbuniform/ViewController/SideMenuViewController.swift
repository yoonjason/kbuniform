//
//  SideMenuViewController.swift
//  kbuniform
//
//  Created by twave on 2020/10/19.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SideMenu

class SideMenuViewController: UIViewController {

    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var calendarBtn: UIButton!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        contactBtn
            .rx
            .tap
            .subscribe(onNext: {
                self.performSegue(withIdentifier: "SideToContact", sender: nil)
            })
            .disposed(by: rx.disposeBag)
        calendarBtn
            .rx
            .tap
            .subscribe(onNext: {
                self.performSegue(withIdentifier: "SideToCalendar", sender: nil)
            })
            .disposed(by: rx.disposeBag)
    }
    
}

extension SideMenuViewController: SideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}
