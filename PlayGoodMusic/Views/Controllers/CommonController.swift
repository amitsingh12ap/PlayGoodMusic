//
//  CommonController.swift
//  Play Good Music
//
//  Created by 13216146 on 09/07/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit
import WebKit

class CommonController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let apiString = urlString {
            if let url = URL(string: apiString) {
                webView.load(URLRequest(url: url))
            }
        }
    }
    

}
