//
//  Utils.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation
import UIKit
class Utils {

    class func updateUserStatus() {
        UserDefaults.standard.set(true, forKey: "userLoggedIn")
    }
    class func isUserLoggedIn() -> Bool{
        return UserDefaults.standard.bool(forKey: "userLoggedIn")
    }
    
}

