//
//  LoginVM.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 15/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation

class LoginVM: Request {
    func socialLogin(_ socialProfile: [String: String],_ login: SocialLoginType, completion: @escaping ((Bool,ASError?)->Void)) {
        
        if let url = URL(string: RequestBuilder.EndPoint.socialLogin.path) {
            var request = URLRequest(url: url)
            try? request.setMultipartFormData(RequestBuilder.Parameters.socialLogin(socialProfile, login.value).path, encoding: .utf8)
            request.httpMethod = HttpMethod.post.rawValue
            self.request(request, LoginModel.self) { (result) in
                switch result {
                case .success(let model):
                    if model?.code ?? 0 == 0 {
                        completion(false, .apiError("Something Went Wrong"))
                        return
                    }
                    completion(true, nil)
                case.failure(let error):
                    completion(false, error)
                }
            }
        }
    }
    
    func login(_ userName: String,_ password: String, completion: @escaping ((Bool,ASError?)->Void)) {
        if let url = URL(string: RequestBuilder.EndPoint.login.path) {
            var request = URLRequest(url: url)
            try? request.setMultipartFormData(RequestBuilder.Parameters.login(userName, password).path, encoding: .utf8)
            request.httpMethod = HttpMethod.post.rawValue
            self.request(request, LoginModel.self) { (result) in
                switch result {
                case .success(let model):
                    if model?.code ?? 0 == 0 {
                        completion(false, .apiError("Something Went Wrong"))
                        return
                    }
                    completion(true, nil)
                case.failure(let error):
                    completion(false, error)
                }
            }
        }
    }
    
    func forgetPassword(completion: @escaping ((Bool,ASError?)->Void)) {
        if let url = URL(string: RequestBuilder.EndPoint.forgetPassword.path) {
            var request = URLRequest(url: url)
            try? request.setMultipartFormData(RequestBuilder.Parameters.forgetPassword("amit.singh@gmail.com").path, encoding: .utf8)
            request.httpMethod = HttpMethod.post.rawValue
            self.request(request, LoginModel.self) { (result) in
                switch result {
                case .success(let model):
                    if model?.code ?? 0 == 0 {
                        completion(false,.apiError(model?.error ?? ""))
                    } else {
                        completion(true,nil)
                    }
                case .failure(let error):
                    completion(false,error)
                }
            }
        }
    }
}
