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
PaymentUrl: https://api.expresspay.sa/post
 
*/

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // https://github.com/yassram/YRPayment
        let expressPayCredential = ExpressPayCredential(
            clientKey: "<merchant key>",
            clientPass: "<merchant password>",
            paymentUrl: "https://api.expresspay.sa/post"
        )
        
        ExpressPaySDK.config(expressPayCredential)
        
        return true
    }
}
