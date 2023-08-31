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

    let itemLoaderService = ItemLoaderService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let mainViewController = makeMainModule()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

extension AppDelegate {

    func makeMainModule() -> UIViewController {
        let mainServiceAssembly = MainModuleServiceAssembly(itemLoaderService: itemLoaderService)
        let mainModuleAssembly = MainModuleAssembly(serviceAssembly: mainServiceAssembly)
        return mainModuleAssembly.makeMainModule()
    }
}
