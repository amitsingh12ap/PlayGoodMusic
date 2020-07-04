//
//  CommonWebController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 04/07/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit
import WebKit
class CommonWebController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var htmlString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let html = self.htmlString else {
            return
        }
        if let url = URL(string: html) {
            self.webView.load(URLRequest(url: url))
        }
    }

}
