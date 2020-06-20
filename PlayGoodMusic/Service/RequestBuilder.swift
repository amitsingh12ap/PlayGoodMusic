//
//  RequestBuilder.swift
//  Networking
//
//  Created by 13216146 on 06/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation


//MARK:- EndPoints
enum EndPoint {
    case login
    case registration
    var path:String {
        switch self {
        case .login:
            return ""
        case .registration:
            return ""
        }
    }
}

//MARK:- Parameters
enum Parameters {
    case login
    case registration
    var path:[String: Any] {
        switch self {
        case .login:
            return [:]
        case .registration:
            return [:]
        }
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
