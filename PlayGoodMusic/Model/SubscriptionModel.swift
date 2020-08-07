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
    let result: SubscriptionResult
}

// MARK: - Result
struct SubscriptionResult: Codable {
    let freeDays, gift, isSubscriber: String
    let packagesList: [PackagesList]
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

// MARK: - PackagesList
struct PackagesList: Codable {
    let packageID, basePkgID, orderID, subscriptionStart: String
    let subscriptionEnd, startDate, endDate, packageMode: String
    let subscriptionID: String
    let gatewayType, regionType: Int
    let stateCode, localUser, title, packagesListDescription: String
    let price, taxValue, period, periodInterval: String
    let packageType, currency: String
    let invoiceURL: String
    let cancelledAt, isCancelled, haveDiscount, discountedPrice: String
    let discountType, discountVal: String
    let isSpecial: Int

    enum CodingKeys: String, CodingKey {
        case packageID = "package_id"
        case basePkgID = "base_pkg_id"
        case orderID = "order_id"
        case subscriptionStart = "subscription_start"
        case subscriptionEnd = "subscription_end"
        case startDate = "start_date"
        case endDate = "end_date"
        case packageMode = "package_mode"
        case subscriptionID = "subscription_id"
        case gatewayType = "gateway_type"
        case regionType = "region_type"
        case stateCode = "state_code"
        case localUser = "local_user"
        case title
        case packagesListDescription = "description"
        case price
        case taxValue = "tax_value"
        case period
        case periodInterval = "period_interval"
        case packageType = "package_type"
        case currency
        case invoiceURL = "invoice_url"
        case cancelledAt = "cancelled_at"
        case isCancelled = "is_cancelled"
        case haveDiscount = "have_discount"
        case discountedPrice = "discounted_price"
        case discountType = "discount_type"
        case discountVal = "discount_val"
        case isSpecial = "is_special"
    }
}
