//
//  SubscriptionModel.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 04/07/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation
// MARK: - SubscriptionModel
struct SubscriptionModel: Codable {
    let code: Int
    let result: SubscriptionModelResult
    enum CodingKeys: String, CodingKey {
        case code
        case result = "result"
    }
}

// MARK: - Result
struct SubscriptionModelResult: Codable {
    let freeDays, gift, isSubscriber: String
    let packagesList: [String]
    let subsLiveItem: [String]
    let subsVODItem: [String]

    enum CodingKeys: String, CodingKey {
        case freeDays = "free_days"
        case gift
        case isSubscriber = "is_subscriber"
        case packagesList = "packages_list"
        case subsLiveItem = "subs_live_item"
        case subsVODItem = "subs_vod_item"
    }
}
