//
//  WebViewController.swift
//  23-Project16
//
//  Created by Arjun Dureja on 2020-05-02.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var website: String?
    var capital: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let website = website {
            let url = URL(string: website)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        
        if let capital = capital {
            title = capital
        }
    }
}
