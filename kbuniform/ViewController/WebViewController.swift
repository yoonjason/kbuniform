//
//  WebViewController.swift
//  kbuniform
//
//  Created by twave on 2020/09/02.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class WebViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
//    var webView : WKWebView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var callBtn: UIButton!
    
    
    let disposeBag = DisposeBag()
    let urlString = "http://localhost:8888/index.php"
    //    let urlString = "http://naver.com"
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        // native -> js call (문서 시작시에만 가능한, 환경설정으로 사용함), source부분에 함수 대신 HTML직접 삽입 가능
        let userScript = WKUserScript(source: "redHeader()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(userScript)
        
        // js -> native call : name의 값을 지정하여, js에서 webkit.messageHandlers.NAME.postMessage("");와 연동되는 것, userContentController함수에서 처리한다
        contentController.add(self, name: "callbackHandler")
        
        config.userContentController = contentController
        
        
        //DidFinish가 되어야 한다.
//        webView.evaluateJavaScript("complete()", completionHandler: { (result, error) in
//            if let result = result {
//                print(result)
//            }
//        })
        
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        // self.view = self.webView!
        self.view.addSubview(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: self.urlString)
        let request = URLRequest(url: url!)
        self.webView.load(request)
        
        callBtn
            .rx
            .tap
            .subscribe(onNext : {
                print("touch")
                self.webView.evaluateJavaScript("callWeb()", completionHandler: { (result, error) -> Void in
                    print(error ?? "no Error")
                    print("result is \(result)")
                })
            })
            .disposed(by: disposeBag)
    }
    
}

extension WebViewController : WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler"){
            print(message.body)
            abc()
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "ok", style: .default) { (action) in
            completionHandler()
        }
        alert.addAction(otherAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("complete()", completionHandler: {(result, error) in
            if let result = result {
                print(result)  // Javascript 함수 complete()에서 반환한 값을 표시
            }
        })
    }
    
    func abc(){
        print("abc Call")
    }
    
    
}
