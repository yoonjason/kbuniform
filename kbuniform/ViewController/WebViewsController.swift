//
//  WebViewsController.swift
//  kbuniform
//
//  Created by twave on 2020/09/07.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import WebKit

class WebViewsController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    let urlString = "http://www.daum.net"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: self.urlString)
        let request = URLRequest(url: url!)
        self.webView.load(request)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        progressView.progress = Float(webView.estimatedProgress)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        // Do any additional setup after loading the view.
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//           if keyPath == "estimatedProgress" {
//               print(self.goodsWebView.estimatedProgress)
//               self.webProgressView.progress = Float(self.goodsWebView.estimatedProgress)
//           }
//        //if(self.webProgressView.progress == 1)
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }

}

extension WebViewsController : WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.progressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        }
        else
        {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
}
