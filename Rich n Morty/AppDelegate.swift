//
//  AppDelegate.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-06.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup key window
        let keyWindow = UIWindow(frame: UIScreen.main.bounds)
        window = keyWindow
        
        // Load directory screen
        let serviceProvider = RMServiceProvider()
        let rmListVM = RMListViewModel(provider: serviceProvider)
        let mainVC = RMCharactersViewController(rmListVM)
        let mainNavController = UINavigationController(rootViewController: mainVC)
        
        keyWindow.rootViewController = mainNavController
        keyWindow.makeKeyAndVisible()
        
        return true
    }
}

