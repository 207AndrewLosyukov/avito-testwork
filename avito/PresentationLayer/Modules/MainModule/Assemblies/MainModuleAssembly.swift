//
//  MainModuleAssembly.swift
//  avito
//
//  Created by Андрей Лосюков on 29.08.2023.
//

import UIKit

final class MainModuleAssembly {

    private let serviceAssembly: MainModuleServiceAssembly

    init(serviceAssembly: MainModuleServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }

    func makeMainModule() -> UIViewController {
        let presenter = MainViewPresenter(serviceAssembly: serviceAssembly)
        let viewController = MainViewController(output: presenter)
        presenter.viewInput = viewController
        return viewController
    }
}

