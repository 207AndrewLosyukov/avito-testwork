//
//  MainViewPresenter.swift
//  avito
//
//  Created by Андрей Лосюков on 29.08.2023.
//

import UIKit

class MainViewPresenter: MainViewOutputProtocol {

    private let service: ItemLoaderServiceProtocol

    private var items = [ProductItem]()

    weak var viewInput: MainViewInputProtocol?

    init(serviceAssembly: MainModuleServiceAssembly) {
        self.service = serviceAssembly.itemLoaderService
    }

    func loadItemsList() {
        viewInput?.setLoadingState()
        service.loadItemsList(handler: {[weak self] result in
            switch(result) {
            case .success(let items):
                self?.items = items.map({ item in
                    ProductItem(model: ProductCellModel(id: Int(item.id) ?? 0, title: item.title, price: item.price, location: item.location, url: item.imageUrl, createdDate: item.createdDate))
                })
                DispatchQueue.main.async {
                    if let items = self?.items {
                        self?.viewInput?.setLoadedState(with: items)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.viewInput?.setErrorState(error: error.localizedDescription)
                }
            }
        })
    }

    private func fetchImage(at index: Int, for model: ProductCellModel) {
        var copyModel = model
        copyModel.isFetching = true
        items[index].model = copyModel
        service.loadItemImage(url: model.url) { [weak self] (result) in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else {
                    return
                }
                copyModel.isFetching = false
                copyModel.image = image
                DispatchQueue.main.async {
                    self?.items[index].model = copyModel
                    if let items = self?.items {
                        self?.viewInput?.updateLoadedState(with: items)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func configure(cell: ProductCell, index: Int) {
        let item = items[index]
        cell.configure(with: item.model)
        if item.model.image == nil && !item.model.isFetching {
            fetchImage(at: index, for: item.model)
        }
    }

    func openDetails(navigationController: UINavigationController?, withItemIndex index: Int) {
        if let navigationController = navigationController {
            let detailsServiceModuleAssembly = DetailsServiceModuleAssembly(itemLoaderService: service)
            let detailsAssembly = DetailsModuleAssembly(serviceAssembly: detailsServiceModuleAssembly)
            navigationController.pushViewController(detailsAssembly.makeDetailsModule(withId: items[index].model.id), animated: false)
        }
    }
}
