//
//  WebViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 13.11.21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: url) else {return}
        webView.load(URLRequest(url: url))

    }

}
