//
//  SplashViewController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()   
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.getMasterApi()
    }

}
extension SplashViewController: Request {
    func getMasterApi() {
        LoadingView.showLoader(withTitle: "Please wait...", toView: self.view)
        let path = RequestBuilder.EndPoint.master.path
        if let url = URL(string: path) {
            let request = URLRequest(url: url)
            self.request(request, MasterResponseModel.self) { (result) in
                switch result {
                case.success(let model):
                    LoadingView.hideLoader()
                    if let masterUrlModel = model {
                        MasterApiListHelper.shared.updateMasterUrlModel(masterUrlModel)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.navigateToHome()
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        LoadingView.showError(withTitle: error.localizedDescription, toView: self.view)
                    }
                }
            }
        }
    }
    
}
