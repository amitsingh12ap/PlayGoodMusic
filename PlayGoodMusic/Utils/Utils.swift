//
//  Utils.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation
import UIKit
struct Utils {
    
    public let bytes: Int64
    
    public var kilobytes: Double {
        return Double(bytes) / 1_024
    }
    
    public var megabytes: Double {
        return kilobytes / 1_024
    }
    
    public var gigabytes: Double {
        return megabytes / 1_024
    }
    
    public init(bytes: Int64) {
        self.bytes = bytes
    }
    
    static func getDate(dateString: String) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatterGet.date(from: dateString) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd,MMM,HH:mm"
            return dateFormatterPrint.string(from: date)
        }
        return nil
    }
    
    public func getReadableUnit() -> String {
        
        switch bytes {
        case 0..<1_024:
            return "\(bytes) bytes"
        case 1_024..<(1_024 * 1_024):
            return "\(String(format: "%.2f", kilobytes)) kb"
        case 1_024..<(1_024 * 1_024 * 1_024):
            return "\(String(format: "%.2f", megabytes)) mb"
        case (1_024 * 1_024 * 1_024)...Int64.max:
            return "\(String(format: "%.2f", gigabytes)) gb"
        default:
            return "\(bytes) bytes"
        }
    }
    
}
extension Utils {
    static func saveUserInfo(_ loginModel: LoginModel?) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(loginModel) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "loggedInUser")
        }
    }
    static func getUserInfo() -> Data? {
        return UserDefaults.standard.object(forKey: "loggedInUser") as? Data
    }
    
    static func updateUserStatus(_ status: Bool? = true) {
        UserDefaults.standard.set(status, forKey: "userLoggedIn")
    }
    static func isUserLoggedIn() -> Bool{
        return UserDefaults.standard.bool(forKey: "userLoggedIn")
    }
    
    static func navigateToLogin( controller: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginScreen = storyBoard.instantiateViewController(identifier: "Login") as! LoginViewController
        if controller.navigationController?.viewControllers.contains(LoginViewController()) ?? false {
            controller.navigationController?.popToViewController(loginScreen, animated: true)
        } else {
            controller.navigationController?.pushViewController(loginScreen, animated: true)
        }
    }
}
