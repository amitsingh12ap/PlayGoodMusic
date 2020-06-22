//
//  LoginModel.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 15/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation
struct LoginModel: Codable {
    let code: Int
//    let result: String?
    let loginResponseResult: LoginResponseResult?
    let error: String?
}

// MARK: - Result
struct LoginResponseResult: Codable {
    let id: Int
    let otp, username, firstName, lastName: String
    let gender, location, address, lat: String
    let long, contactNo, email, aboutMe: String
    let ageGroup, image, status, optionCode: String
    let provider, country, countryCode, city: String
    let state: String

    enum CodingKeys: String, CodingKey {
        case id, otp, username
        case firstName = "first_name"
        case lastName = "last_name"
        case gender, location, address, lat, long
        case contactNo = "contact_no"
        case email
        case aboutMe = "about_me"
        case ageGroup = "age_group"
        case image, status
        case optionCode = "option_code"
        case provider, country
        case countryCode = "country_code"
        case city, state
    }
}
