//
//  RegistrationVM.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 16/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation
class RegistrationVM: Request {
    
    func isEmailValid(_ email: String) -> Bool {
        let emailValidator = VaildatorFactory.validatorFor(type: .email)
        let validatedEmail = try? emailValidator.validated(email)
        return validatedEmail?.count ?? 0 > 0
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordValidator = VaildatorFactory.validatorFor(type: .password)
        let validatedPassword = try? passwordValidator.validated(password)
        return validatedPassword?.count ?? 0 > 0
    }
    
    func isValidConfirmPassword(_ password: String, _ confirmPassword: String) -> Bool  {
        let passwordValidator = VaildatorFactory.validatorFor(type: .password)
        let validatedPassword = try? passwordValidator.validated(password)
        let validatedCnfPassword = try? passwordValidator.validated(confirmPassword)
        return validatedPassword?.count ?? 0 > 0 && validatedCnfPassword?.count ?? 0 > 0 && validatedPassword == validatedCnfPassword
    }
    
    private func validate(_ registrationDict: [String: String?])-> Bool {
        for (_,value) in registrationDict {
            if value?.count ?? 0 == 0 {
                return false
            }
        }
        return true
    }
    
    func registerUser(_ firstName: String, _ lastName: String,_ mobileNo: String, _ email: String, password: String, compeletion: @escaping (Bool, ASError?)-> Void) {
        let params = RequestBuilder.Parameters.registration(firstName, lastName, mobileNo, email, password).path
        if validate(params) {
            if let url = URL(string: RequestBuilder.EndPoint.registration.path) {
            var request = URLRequest(url: url)
            try? request.setMultipartFormData(params, encoding: .utf8)
                request.httpMethod = HttpMethod.post.rawValue
                self.request(request, RegistrationModel.self) { (result) in
                    switch result {
                    case .success(let model):
                        if model?.code ?? 0 == 1 {
                            compeletion(true,.apiError( model?.result ?? ""))
                        }
                    case .failure(let error):
                        compeletion(false,error)
                    }
                }
            }
        }
        
    }
}
