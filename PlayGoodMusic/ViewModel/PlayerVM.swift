//
//  PlayerVM.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 04/07/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation

struct PlayerVM:Request {
    func getUserSubscription(completion:@escaping (SubscriptionModel?, ASError? )->Void){
        if let loggedInData = Utils.getUserInfo() {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginModel.self, from: loggedInData) {
                let path = RequestBuilder.EndPoint.userPackage(loadedPerson.loginResponseResult?.email ?? "", loadedPerson.loginResponseResult?.username ?? "").path
                if let url = URL(string: path) {
                    let request = URLRequest(url: url)
                    self.request(request, SubscriptionModel.self) { (result) in
                        switch result {
                        case .success(let model):
                            completion(model, nil)

                        case .failure(let error):
                            completion(nil,error)
                        }
                    }
                }
            }
        } else {
            let error = ASError.apiError("not loggedIn")
            completion(nil,error)
        }
    }
}
