//
//  AppDelegate.swift
//  MetaData
//
//  Created by Pawan  on 25/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = DashboardViewController()
        window?.makeKeyAndVisible()

        return true
    }
}

