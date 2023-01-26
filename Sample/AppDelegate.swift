//
//  AppDelegate.swift
//  Sample
//
//  Created by ExpressPay(zik) on 10.03.2021.
//

import UIKit
import ExpressPaySDK

/*

// Express Pay
// -----------------
ClientKey <CLIENT MERCHANT KEY>
ClientPass: <CLIENT MERCHANT PASSWORD>
PaymentUrl: https://api.expresspay.sa/post
*/

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let expressPayCredential = ExpressPayCredential(
            clientKey: "<CLIENT MERCHANT KEY>",
            clientPass: "<CLIENT MERCHANT PASSWORD>",
            paymentUrl: "https://api.expresspay.sa/post"
        )
        
        ExpressPaySDK.config(expressPayCredential)
        
        return true
    }
}
