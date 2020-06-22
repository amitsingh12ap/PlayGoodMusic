//
//  BaseViewController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController {
    let signupColor = UIColor(red: 145.0/255.0, green: 132.0/255.0, blue: 16.0/255.0, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMusicImage()
        self.navigationController?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func addSignupButton(){
        let signupButton = UIBarButtonItem.init(title: "SIGN UP", style: .plain, target: self, action: #selector(SignupAction))
        signupButton.tintColor = signupColor
        self.navigationItem.rightBarButtonItem = signupButton
    }
    
    func navigateToHome(){
           self.performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    func navigateToLogin() {
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    @objc private func SignupAction() {
        print("signup")
        self.performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    
    func showAlert(_ title: String,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showActionAlert(_ title: String, _ message: String, completion:@escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .cancel, handler: { (action) in
            completion()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func addMusicImage() {
        let logo = UIImage(named: "PGM.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    
}

extension BaseViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: SplashViewController.self) {
            self.navigationController?.navigationBar.isHidden = true
            self.navigationItem.setHidesBackButton(true, animated: true);
        } else {
            self.navigationItem.setHidesBackButton(true, animated: true);
            self.navigationController?.navigationBar.isHidden = false
        }
        
        // verify Back button
        if viewController.isKind(of: LoginViewController.self) {
            self.addSignupButton()
            self.navigationItem.setHidesBackButton(true, animated: true);
        }
        else if viewController.isKind(of: LiveEventsViewController.self) {
            addMusicImage()
            self.navigationItem.setHidesBackButton(true, animated: true);
        } else {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        }
    }
    
}

