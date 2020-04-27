//
//  DetailViewController.swift
//  10-Project7
//
//  Created by Arjun Dureja on 2020-04-26.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%, font-family: HelveticaNeue-Light; } </style>
        </head>
        <body>
        <h2 style="color:white">\(detailItem.body)</h2>
        </body>
        </html>
        """
        
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.loadHTMLString(html, baseURL: nil)
    }

}
