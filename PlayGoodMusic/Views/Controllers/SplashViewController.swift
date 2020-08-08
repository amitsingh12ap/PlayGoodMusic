//
//  SplashViewController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit
import AVKit

class SplashViewController: BaseViewController {
    private var isApifinished: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.async {
            self.view.backgroundColor = .black
             self.getMasterApi()
        }
        
        if let path = Bundle.main.path(forResource: "splash_1", ofType: "mp4") {
            let videoContainerView = UIView(frame: self.view.frame)
            let player = VideoView(frame: videoContainerView.frame)
            videoContainerView.addSubview(player)
            self.view.addSubview(videoContainerView)
            player.playerLayer.videoGravity = .resizeAspectFill
            player.play(with: URL(fileURLWithPath: path))
            player.delegate = self
        }
        
        
    }

}
extension SplashViewController: Request {
//    func checkSession() {
////        http://15.206.0.197:9008/automatorapi/v8/customer/session/token/5ec141697b27f
//        LoadingView.showLoader(withTitle: "Please wait...", toView: self.view)
//        let path = RequestBuilder.EndPoint.session.path
//        if let url = URL(string: path) {
//            let request = URLRequest(url: url)
//            self.request(<#T##request: URLRequest##URLRequest#>, <#T##model: (Decodable & Encodable).Protocol##(Decodable & Encodable).Protocol#>, completion: <#T##((Result<(Decodable & Encodable)?, ASError>) -> Void)##((Result<(Decodable & Encodable)?, ASError>) -> Void)##(Result<(Decodable & Encodable)?, ASError>) -> Void#>)
//        }
//    }
    func getMasterApi() {
        LoadingView.showLoader(withTitle: "Please wait...", toView: self.view)
        let path = RequestBuilder.EndPoint.master.path
        if let url = URL(string: path) {
            let request = URLRequest(url: url)
            self.request(request, MasterResponseModel.self) {[weak self] (result) in
                switch result {
                case.success(let model):
                    LoadingView.hideLoader()
                    if let masterUrlModel = model {
                        
                        MasterApiListHelper.shared.updateMasterUrlModel(masterUrlModel)
                        let sessionPath = RequestBuilder.EndPoint.session.path
                        if let url = URL(string: sessionPath) {
                            var request = URLRequest(url: url)
                            let params = RequestBuilder.Parameters.commonParams.path
                            do {
                               try request.setMultipartFormData(params, encoding: .utf8)
                            } catch {
                                print("failed")
                            }
                            request.httpMethod = HttpMethod.post.rawValue
                            self?.request(request, RegistrationModel.self, completion: { (result) in
                                self?.isApifinished = true
                            })
                        }
                        
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        if let strongSelf = self {
                            LoadingView.showError(withTitle: error.localizedDescription, toView: strongSelf.view)
                        }
                        
                    }
                }
            }
        }
    }
    
}
extension SplashViewController: VideoViewDelegate {
    func updatePlayerStatus(status: AVPlayerItem.Status) {
    }
    
    func updateCurrentTime(_ time: CMTime) {
        
    }
    
    func playerDidFinishedPlaying() {
        print("player finished")
        if isApifinished {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.navigateToHome()
            }
        }
    }
    
}
