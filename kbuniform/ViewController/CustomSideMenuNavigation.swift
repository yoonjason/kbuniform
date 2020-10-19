//
//  CustomSideMenuNavigation.swift
//  kbuniform
//
//  Created by twave on 2020/10/19.
//  Copyright © 2020 seokyu. All rights reserved.
//

import Foundation
import SideMenu

class CustomSideMenuNavigation : SideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSideMenu()
        
    }
    
    private func setSideMenu(){
        self.presentationStyle = .menuSlideIn
        self.leftSide = true
        self.menuWidth = self.view.frame.size.width*0.7
    }
    
}


