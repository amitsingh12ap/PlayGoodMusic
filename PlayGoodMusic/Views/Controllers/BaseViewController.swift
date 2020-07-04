//
//  BaseViewController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

let kForceSubscription = "subscribe_now"
class BaseViewController: UIViewController {
    let signupColor = UIColor(red: 145.0/255.0, green: 132.0/255.0, blue: 16.0/255.0, alpha: 1)
    let menuButtonColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
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
    private func addMenuOption() {
        let menuButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(menuAction))
        menuButton.tintColor = menuButtonColor
        self.navigationItem.leftBarButtonItem = menuButton
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
    
    @objc func menuAction() {
        print("menu")
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
    
    func showConfirmationAlert(_ title: String, _ message: String, completion:@escaping (Bool)->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: { (action) in
            completion(true)
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: { (action) in
            completion(false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func addMusicImage() {
        let logo = UIImage(named: "PGM.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    @objc func updatePlayerView(_ isLandscape: Bool) {
        
    }
}

extension BaseViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !(viewController is PlayerViewController) {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        if viewController.isKind(of: SplashViewController.self) {
            self.navigationController?.navigationBar.isHidden = true
            self.navigationItem.setHidesBackButton(true, animated: true);
        } else {
            self.navigationItem.setHidesBackButton(true, animated: true);
            self.navigationController?.navigationBar.isHidden = false
        }
        if viewController.isKind(of: PlayerViewController.self) {
            self.navigationController?.navigationBar.isHidden = true
            return
        }
        
        // verify Back button
        if viewController.isKind(of: LoginViewController.self) {
            self.addSignupButton()
            self.navigationItem.setHidesBackButton(true, animated: true);
        }
        else if viewController.isKind(of: LiveEventsViewController.self) {
            addMusicImage()
            addMenuOption()
            self.navigationItem.setHidesBackButton(true, animated: true);
        } else if viewController.isKind(of: ProfileViewController.self) {
            self.navigationItem.setHidesBackButton(false, animated: true);
        }
        else {
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController.navigationBar.titleTextAttributes = textAttributes
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
               print("landscape")
                self.updatePlayerView(true)
           } else {
               print("portrait")
                self.updatePlayerView(false)
           }
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        if navigationController.topViewController is PlayerViewController {
            return .all
        }
        return .portrait
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if self.navigationController?.topViewController is PlayerViewController {
                return .all
            }
            return .portrait
        }
    }
    
    override var shouldAutorotate: Bool {
        return self.navigationController?.topViewController?.shouldAutorotate ?? false
    }
}

