//
//  ApplePayInitiater.swift
//  Sample
//
//  Created by Zohaib Kambrani on 24/01/2023.
//

import Foundation
import UIKit
import WebKit
import ExpressPaySDK


class ApplePayInitiater : UIViewController{
    
    var target:UIViewController?
    class func newInstance(target:UIViewController) -> ApplePayInitiater{
        let vc = ApplePayInitiater()
        vc.target = target
        return vc
    }
    
    private var logs:Bool = true
    private var onTransactionSuccess:((ExpressPay3dsResponse)->Void)?
    private var onTransactionFailure:((ExpressPay3dsResponse)->Void)?
    
    var webView:WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.loadHTMLString("<html></html>", baseURL: URL(string: "https://pay.expresspay.sa"))
        view = webView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        interact()
    }
    
    func interact(){
        if let filepath = Bundle.main.path(forResource: "ExpressApplePay", ofType: "js") {
            
            if let js = try? String(contentsOfFile: filepath){
                self.webView?.evaluateJavaScript(js, completionHandler: { result, error in
                    self.webView?.evaluateJavaScript("doIt()", completionHandler: { res, err in
                        print(res)
                    })
                })
            }
            
            
        } else {
            print("ExpressApplePay.js not found")
        }
    }
}

extension ApplePayInitiater{
    
    private func operationCompleted(result:ExpressPay3dsResponse){
        if result.result == .success{
            self.dismiss(animated: true) {
                self.onTransactionSuccess?(result)
            }
        }else if result.result == .failure{
            self.dismiss(animated: true) {
                self.onTransactionFailure?(result)
            }
        }
    }
    
    private func parseHttpBody(httpBody:Data) -> ExpressPay3dsResponse?{
        var dictionary:[String:String] = [:]
        
        if let bodyString = String(data: httpBody, encoding: .utf8){
            
            bodyString.components(separatedBy: "&")
                .forEach { i in
                    let keyValue = i.components(separatedBy: "=")
                    if keyValue.count == 2,
                       let key  = keyValue.first,
                       let value  = keyValue.last{
                        dictionary[key] = value
                    }
            }
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary){
            
            let response = try? JSONDecoder().decode(ExpressPay3dsResponse.self, from: jsonData)

            return response
            
        }
    
        return nil
    }
    
    
    private func logRequest(request:URLRequest){
        if logs == false{
            return
        }
        
        let url = request.url?.description ?? ""
        let body = String(data: request.httpBody ?? Data(), encoding: .utf8)  ?? "None"
        
        if logs{
            debugPrint("------------------------------------------------------------------------------------------------------------------------------")
            debugPrint("3DS Verification Redirection")
            debugPrint("------------------------------------------------------------------------------------------------------------------------------")
            debugPrint("URL: \(url)")
            debugPrint("Params: \(body)")
            debugPrint("------------------------------------------------------------------------------------------------------------------------------")
            print("\n\n\n\n\n\n")
        }
    }
}

extension ApplePayInitiater : WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(webView)
        
        let url = navigationAction.request.url?.description ?? ""
        let body = String(data: navigationAction.request.httpBody ?? Data(), encoding: .utf8)  ?? "None"
        
        logRequest(request: navigationAction.request)
    
        if url.lowercased().starts(with: "https://api.expresspay.sa/verify/"), let body = navigationAction.request.httpBody{
            if let params = parseHttpBody(httpBody: body){
                if params.result != nil{
                    operationCompleted(result: params)
                }
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        interact()
    }
}

extension ApplePayInitiater : WKUIDelegate{
    
}

extension UIView {
    func attachAnchors(to view: UIView, with insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left)
        ])
    }
}
