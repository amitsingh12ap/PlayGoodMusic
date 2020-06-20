//
//  Request.swift
//  Networking
//
//  Created by 13216146 on 06/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation

protocol Request {
    func request<T: Codable>(_ request: URLRequest,_ model: T.Type, completion: @escaping ((Result<T?,ASError>)->Void))
}

extension Request {
    
    private func callApi<T:Codable>(request: URLRequest,_ model: T.Type,completion: @escaping ((T?, ASError?)->Void)) -> URLSessionTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let apiError = error {
                completion(nil, .apiError(apiError.localizedDescription))
                return
            }
            guard let responseData = data else {
                completion(nil, .apiFailure)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(model.self, from: responseData)
                completion(model,nil)
            } catch {
                completion(nil,.invalidJson)
            }
        }
    }
    
    func getRequest(_ requestParams: [String: Any]?, _ headers: [String: Any]?, endPoint: String)-> URLRequest? {
        if let url = URL(string: endPoint) {
            var request = URLRequest(url: url)
            do {
                if let params = requestParams {
                    let data = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
                    request.httpBody = data
                }
            } catch {
                print("no parameters found")
            }
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let apiHeaders = headers {
                for (key,value) in apiHeaders {
                    request.setValue("\(value)", forHTTPHeaderField: key)
                }
            }
            
            return request
        }
        return nil
    }
    
    func request<T: Codable>(_ request: URLRequest,_ model: T.Type, completion: @escaping ((Result<T?,ASError>)->Void)) {
        callApi(request: request, model.self) { (responseModel, error) in
            
            if let model = responseModel {
                completion(.success(model))
            } else {
                if let apiError = error {
                    completion(.failure(apiError))
                } else {
                    completion(.failure(.apiFailure))
                }
                
            }
            
        }.resume()
    }
    
}
