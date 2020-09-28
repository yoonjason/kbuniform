//
//  Common.swift
//  kbuniform
//
//  Created by twave on 2020/09/02.
//  Copyright © 2020 seokyu. All rights reserved.
//

import Foundation
import UIKit

enum SegueIndentifier: String {
    case MOVETOWEBVIEW = "movetowebview"
    case MOVETOLOGINVIEW = "movetologinview"
    case MOVETOCHATLIST = "movetochatlist"
    case MOVETOTESTCHAT = "movetotestchatlist"
    case MOVETOMESSAGE = "movetomessage"
}


class Globals {
    private init() {

    }

    static let shared = Globals()

    func setUserDefaults(withValue: Any, key: String) {
        UserDefaults.standard.set(withValue, forKey: key)
    }

    func getUserDefaults(key: String) -> Any {
        return UserDefaults.standard.object(forKey: key)
    }

    func removeUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    func getUserDefaultsBool(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}
