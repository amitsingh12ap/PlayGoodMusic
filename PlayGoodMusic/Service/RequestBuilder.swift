//
//  RequestBuilder.swift
//  Networking
//
//  Created by 13216146 on 06/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony
//MARK:- EndPoints
let kBaseUrl = "http://15.206.0.197:9008/automatorapi/v8/master/"
let kToken = "5ec141697b27f"

struct RequestBuilder {
    enum EndPoint {
        case master
        case login
        case socialLogin
        case registration
        case forgetPassword
        case contactUs
        case liveEvents(String)
        case terms
        case privacyPolicy
        case session
        case userPackage(String,String)
        var path:String {
            switch self {
            case .master:
                return kBaseUrl+"url_staging_good_music/token/5ec141697b27f/device/ios"
            case .login:
                return self.fixUrlString(MasterApiListHelper.shared.masterUrlInfo?.result?.login ?? "")+kToken
            case .registration:
                return self.fixUrlString(MasterApiListHelper.shared.masterUrlInfo?.result?.add ?? "")+kToken
            case .forgetPassword:
                return self.fixUrlString(MasterApiListHelper.shared.masterUrlInfo?.result?.forgot ?? "")+kToken
            case .socialLogin:
                return self.fixUrlString(MasterApiListHelper.shared.masterUrlInfo?.result?.social ?? "")+kToken
            case .liveEvents(let totalCount):
                return self.fixUrlString("\(MasterApiListHelper.shared.masterUrlInfo?.result?.live ?? "")\(kToken)/live_offset/0/live_limit/\(totalCount)/device/iOS")
            case .contactUs:
                return self.fixUrlString("\(MasterApiListHelper.shared.masterUrlInfo?.result?.contact_us ?? "")\(kToken)")
            case .terms :
                return self.fixUrlString("\(MasterApiListHelper.shared.masterUrlInfo?.result?.t_c ?? "")\(kToken)")
            case .privacyPolicy:
                return self.fixUrlString("\(MasterApiListHelper.shared.masterUrlInfo?.result?.privacy_policy ?? "")\(kToken)")
            case .userPackage(let userName, let userID):
                return self.fixUrlString("\(MasterApiListHelper.shared.masterUrlInfo?.result?.subs_user_subscriptions ?? "")\(kToken)/device/iOS/uid/\(userID)/username/\(userName)")
            case .session:
                return self.fixUrlString(MasterApiListHelper.shared.masterUrlInfo?.result?.csession ?? "")+kToken
            }
            
        }
        
        private func fixUrlString(_ string: String)-> String {
            return string.replacingOccurrences(of: "0|,", with: "")
        }
    }
    
    //MARK:- Parameters
    enum Parameters {
        case login(String, String)
        case socialLogin([String: String], String)
        case registration(String,String,String,String,String)
        case forgetPassword(String)
        case commonParams
        var path:[String: String] {
            switch self {
            case .login(let email, let password):
                var params = commornParams
                params["email"] = email
                params["password"] = password
                return params
            case .registration(let firstName, let lastName, let mobileNo, let email, let password):
                var params = commornParams
                params["first_name"] = firstName
                params["last_name"] = lastName
                params["phone"] = mobileNo
                params["password"] = password
                params["email"] = email
                return params
            case .socialLogin(let loggedInUserInfo, let provider):
                var params = commornParams
                params["social"] = RequestBuilder.jsonString(loggedInUserInfo)
                params["type"] = "social"
                params["provider"] = provider
                return params
            case .forgetPassword(let emailID):
                return DeviceInfo.forgetPasswordDict(emailID)
            case .commonParams:
                return commornParams
            }
        }
        
        private var commornParams: [String: String] {
            return ["devicedetail": "\(DeviceInfo.detailsJsonStirng ?? "")", "device_other_detail": "\(DeviceInfo.otherDetailsJsonStirng ?? "")"]
        }
    }
}

struct DeviceInfo {
    
    static var detailsJsonStirng: String? {
        return jsonString(self.details)
    }
    
    static var otherDetailsJsonStirng: String? {
        return jsonString(self.otherDetails)
    }
    
    static var forgetPasswordJsonString:(String) -> String? = { (email) in
        return jsonString(forgetPasswordDict(email))
    }
    
    
    
    static var forgetPasswordDict:(String) -> [String: String] = { (emailId) in
        return ["email": emailId, "device_unique_id": UIDevice.current.identifierForVendor?.uuidString ?? ""]
    }
    
    private static var details: [String: String] {
        return ["make_model": UIDevice.current.modelName,"os": "iOS","screen_resolution": "\(UIDevice.current.screenWidth)*\(UIDevice.current.screenHeight)","push_device_token":"fdsfdsh:RDFGGS43_YiSFzzaOrztVA7tooNKWmUrh2i","device_type":"app","platform":"iOS","device_unique_id": UIDevice.current.identifierForVendor?.uuidString ?? "", "one_signal_id":"5f949ff2-1cd5-4fd6-8e2c-3771610592c0"]
    }
    private static var otherDetails: [String: String] {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return ["os_version":UIDevice.current.systemVersion,"app_version":appVersion ?? "","network_type":self.getNetworkType(),"network_provider":dataServiceProvider]
    }
    
    static func getNetworkType()->String {
        let telefonyInfo = CTTelephonyNetworkInfo()
        if let radioAccessTechnology = telefonyInfo.serviceCurrentRadioAccessTechnology {
            print(radioAccessTechnology)
            switch radioAccessTechnology["0000000100000001"]{
            case CTRadioAccessTechnologyLTE: return "LTE (4G)"
            case CTRadioAccessTechnologyWCDMA: return "3G"
            case CTRadioAccessTechnologyEdge: return "EDGE (2G)"
            default:
                break
            }
        }
        return "Other"
    }
    
    private static var dataServiceProvider: String {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrierDict = networkInfo.serviceSubscriberCellularProviders
        if let carrier = carrierDict?["0000000100000001"] {
            return carrier.carrierName ?? ""
        }
        return ""
    }
    
    private static func jsonString(_ dict: [String: String]) -> String? {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dict) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
}

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var screenWidth:String {
        return "\(UIScreen.main.bounds.width)"
    }
    var screenHeight:String {
        return "\(UIScreen.main.bounds.height)"
    }
}

//MARK:- ERROR
enum Result<T,E> where E: Error {
    case success(T)
    case failure(E)
}

enum ASError: Error {
    case invalidURL
    case invalidJson
    case apiFailure
    case apiError(String)
    
    var localizedDescription: String {
        switch self {
        case .apiFailure:
            return "Something went wrong. Please try again later"
        case .invalidJson:
            return "Please check api resposne as json is invalid"
        case .invalidURL:
            return "Invalid api Request"
        case .apiError(let errorMessage):
            return errorMessage
        }
    }
}
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
enum SocialLoginType {
    case facebook
    case google
    
    var value: String {
        switch self {
        case .facebook:
            return "facebook"
        case .google:
            return "g0ogle"
        }
    }
}
extension RequestBuilder {
    static func jsonString(_ dict: [String: String]) -> String? {
           let encoder = JSONEncoder()
           if let jsonData = try? encoder.encode(dict) {
               if let jsonString = String(data: jsonData, encoding: .utf8) {
                   return jsonString
               }
           }
           return ""
       }
}
