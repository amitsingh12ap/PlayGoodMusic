//
//  MasterApiListHelper.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation

class MasterApiListHelper {
    static let shared = MasterApiListHelper()
    private var savedMasterUrl: String?
    private init(){}
    
    private func getEncodedData(_ model:MasterResponseModel)-> String? {
        let enocder = JSONEncoder()
        if let encoded = try? enocder.encode(model) {
            if let json = String(data: encoded, encoding: .utf8) {
                return json
            }
        }
        return nil
    }
    private func getDecodedData()-> MasterResponseModel? {
        if let masterUrl = self.savedMasterUrl {
            if let data = masterUrl.data(using: .utf8) {
                let decoder = JSONDecoder()
                if let model = try? decoder.decode(MasterResponseModel.self, from: data) {
                    return model
                }
            }
        }
        return nil
    }
    
    var masterUrlInfo:MasterResponseModel? {
        return getDecodedData()
    }
    
    func updateMasterUrlModel(_ model: MasterResponseModel){
        self.savedMasterUrl = self.getEncodedData(model)
    }
}
extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
