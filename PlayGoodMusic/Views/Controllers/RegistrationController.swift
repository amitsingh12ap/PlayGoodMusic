//
//  RegistrationController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 15/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

class RegistrationController: BaseViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobileNo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var agreementBtn: UIButton!
    @IBOutlet weak var newsLetterButton: UIButton!
    
    var model = RegistrationVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerAction(_ sender: Any) {
        if model.isEmailValid(email.text ?? "") && model.isPasswordValid(password.text ?? "") &&    model.isValidConfirmPassword(password.text ?? "", confirmPassword.text ?? "") && agreementBtn.isSelected {
            model.registerUser(firstName.text ?? "", lastName.text ?? "", mobileNo.text ?? "", email.text ?? "", password: password.text ?? "") { (status, error) in
                if(status) {
                    DispatchQueue.main.async {
                        self.showActionAlert("Success", "Registered Successfully") {
                            self.navigateToLogin()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("Error", error?.localizedDescription ?? "Failed to Register user.")
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.showAlert("Error", "Please provide complete data as fields are mandatory")
            }
        }
        
    }
    
    @IBAction func agreementAction(_ sender: Any) {
        self.agreementBtn.isSelected = !self.agreementBtn.isSelected
    }
    
    @IBAction func readNewsLetterAction(_ sender: Any) {
        self.newsLetterButton.isSelected = !self.newsLetterButton.isSelected
    }
    
    

}
