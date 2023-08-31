//
//  DetailsModuleAssembly.swift
//  avito
//
//  Created by Андрей Лосюков on 29.08.2023.
//

import UIKit

final class DetailsModuleAssembly {
    let serviceAssembly: DetailsServiceModuleAssembly

    init(serviceAssembly: DetailsServiceModuleAssembly) {
        self.serviceAssembly = serviceAssembly
    }

    func makeDetailsModule(withId id: Int) -> UIViewController {
        let presenter = DetailsViewPresenter(id: id, service: serviceAssembly.itemLoaderService)
        let detailsViewController = DetailsViewController(output: presenter)
        presenter.viewInput = detailsViewController
        return detailsViewController
    }
}
