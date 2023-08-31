//
//  AppDelegate.swift
//  avito
//
//  Created by Андрей Лосюков on 24.08.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let serviceAssembly = MainModuleServiceAssembly(itemLoaderService: ItemLoaderService())

        let mainModuleAssembly = MainModuleAssembly(serviceAssembly: serviceAssembly)
        let navigationController = UINavigationController(rootViewController: mainModuleAssembly.makeMainModule())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
