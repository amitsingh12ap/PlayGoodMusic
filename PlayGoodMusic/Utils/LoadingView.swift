//
//  LoadingView.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    static var activityIndicator = UIActivityIndicatorView()
    static var strLabel = UILabel()
    static let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
    static let containerView = UIView()
    
    private static func addLoadingView(_ view: UIView, withTitle title: String) {
        containerView.frame = view.frame
        containerView.backgroundColor = UIColor.clear
        
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: containerView.frame.size.height - 100 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
//        effectView.dropShadow()
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        containerView.addSubview(effectView)
        view.window?.addSubview(containerView)
    }
    static func showLoader(withTitle title: String,toView view: UIView) {
        print(#function)
        self.addLoadingView(view, withTitle: title)
    }
    
    static func showError(withTitle title: String,toView view: UIView) {
        self.addLoadingView(view, withTitle: title)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.hideLoader()
        }
    }
    
    static func hideLoader() {
        print(#function)
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
        }
    }
    
}
