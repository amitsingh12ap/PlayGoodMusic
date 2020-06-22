//
//  LoginViewController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit
import TNSocialNetWorkLogin

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    var selectedSocialLogin: SocialLoginType?
    var model = LoginVM()
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    @IBAction func forgetPasswordAction(_ sender: Any) {
        model.forgetPassword { (status, error) in
            if let apiError = error {
                print("apiError\(apiError)")
                return
            }
        }
    }
    @IBAction func loginAction(_ sender: Any) {
        self.view.endEditing(true)
        self.login()
    }
    private func login() {
        LoadingView.showLoader(withTitle: "Please wait...", toView: self.view)
               
        let emailValidator = VaildatorFactory.validatorFor(type: .email)
        let passwordValidator = VaildatorFactory.validatorFor(type: .password)
        guard let email = try? emailValidator.validated(emailTxtField.text ?? "") else {
            LoadingView.hideLoader()
            self.showAlert("error", "Invalid EmailId")
            return
        }
        
        guard let password = try? passwordValidator.validated(passwordTxtField.text ?? "")else {
            LoadingView.hideLoader()
            self.showAlert("error", "Invalid password")
            return
        }
        
        model.login(email, password) {[weak self] (status, error) in
            DispatchQueue.main.async {
                LoadingView.hideLoader()
                if let apiError = error {
                    self?.showAlert("Error", apiError.localizedDescription)
                    return
                }
            }
            DispatchQueue.main.async {
                Utils.updateUserStatus()
                self?.navigateToHome()
            }
            
        }
    }
    
    private func socialLogin(_ user: TNUser) {
        let userInfo = ["id": user.userId ?? "","first_name": user.firstName ?? "", "last_name": user.lastName ?? "", "gender": "", "link": "","locale": "", "name": user.name ?? "", "email": user.email ?? "", "location": "","dob": ""]
        DispatchQueue.main.async {
            self.model.socialLogin(userInfo, self.selectedSocialLogin ?? SocialLoginType.facebook, completion: {[weak self] (isLoggedIn, error) in
                DispatchQueue.main.async {
                    if isLoggedIn {
                        DispatchQueue.main.async {
                            Utils.updateUserStatus()
                            self?.navigateToHome()
                        }
                    } else {
                        self?.showAlert("error", "Failed to Login")
                    }
                }  
            })
        }
    }
    
    @IBAction func facebookAction(_ sender: Any) {
        let permission = TNFacebookPermission()
        permission.publicProfile = ["email": ["name"]]
        self.selectedSocialLogin = .facebook
        TNAuthenticationManager.shared.obtainAuthentication().signInByFacebook(withReadPermissions: nil, from: nil) {[weak self] (result) in
               switch result {
                   case .error(let error):
                       //Got an error while login.
                       print(error.localizedDescription)
                       break
                   case .cancel:
                       //When user canceled.
                       print("the user cancel to login")
                       break
                   case .success(let user):
                       //Login success
                        self?.socialLogin(user)
                       break
               }
           }

    }
    @IBAction func googleAction(_ sender: Any) {
        self.selectedSocialLogin = .google
        TNAuthenticationManager.shared.obtainAuthentication().signInByGoogle() {[weak self] (result) in
            switch result {
                case .error(let error):
                    //Got an error while login.
                    print(error.localizedDescription)
                    break
                case .cancel:
                    //When user canceled.
                    print("the user cancel to login")
                    break
                case .success(let user):
                        self?.socialLogin(user)
                    break
            }
        }

    }
}

