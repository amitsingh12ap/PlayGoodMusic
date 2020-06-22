//
//  Request.swift
//  Networking
//
//  Created by 13216146 on 06/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation

public enum MultipartFormDataEncodingError: Error {
    case characterSetName
    case name(String)
    case value(String, name: String)
}

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
            print(responseData.convertToDictionary() ?? "failed to parse dict")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil,.apiFailure)
                    return
                }
            }
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(model.self, from: responseData)
                completion(model,nil)
            } catch {
                print(error)
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



extension URLRequest {
     public mutating func setMultipartFormData(_ parameters: [String: String], encoding: String.Encoding) throws {

           let makeRandom = { UInt32.random(in: (.min)...(.max)) }
           let boundary = String(format: "------------------------%08X%08X", makeRandom(), makeRandom())

           let contentType: String = try {
               guard let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(encoding.rawValue)) else {
                   throw MultipartFormDataEncodingError.characterSetName
               }
               return "multipart/form-data; charset=\(charset); boundary=\(boundary)"
           }()
           addValue(contentType, forHTTPHeaderField: "Content-Type")

           httpBody = try {
               var body = Data()

               for (rawName, rawValue) in parameters {
                   if !body.isEmpty {
                       body.append("\r\n".data(using: .utf8)!)
                   }

                   body.append("--\(boundary)\r\n".data(using: .utf8)!)

                   guard
                       rawName.canBeConverted(to: encoding),
                       let disposition = "Content-Disposition: form-data; name=\"\(rawName)\"\r\n".data(using: encoding) else {
                       throw MultipartFormDataEncodingError.name(rawName)
                   }
                    body.append(disposition)

                   body.append("\r\n".data(using: .utf8)!)

                   guard let value = rawValue.data(using: encoding) else {
                       throw MultipartFormDataEncodingError.value(rawValue, name: rawName)
                   }
                if rawName == "devicedetail" || rawName == "device_other_detail" || rawName == "social" {
                    if let data = rawValue.data(using: .utf8) {
                        
                        do {
                            let dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:String]
                            let encoder = JSONEncoder()
                            if let jsonData = try? encoder.encode(dictonary) {
                                body.append(jsonData)
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                } else {
                    body.append(value)
                }
                   
               }

               body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

               return body
           }()
       }
}
extension Data {
    func convertToDictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
