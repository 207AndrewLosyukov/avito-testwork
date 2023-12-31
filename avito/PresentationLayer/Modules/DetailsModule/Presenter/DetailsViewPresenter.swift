//
//  DetailsViewPresenter.swift
//  avito
//
//  Created by Андрей Лосюков on 29.08.2023.
//

import Foundation

final class DetailsViewPresenter: DetailsViewOutputProtocol {

    private let service: ItemLoaderServiceProtocol
    private let id: Int

    weak var viewInput: DetailsViewInputProtocol?

    init(id: Int, service: ItemLoaderServiceProtocol) {
        self.id = id
        self.service = service
    }

    func loadDetails() {
        viewInput?.setLoadingWithoutImageState()
        self.service.loadItemDetails(id: id) { [weak self] result in
            switch (result) {
            case .success(let detailsModel):
                DispatchQueue.main.async {
                    self?.viewInput?.setLoadedWithoutImageState(detailsModel: detailsModel)
                    self?.viewInput?.setLoadingWithImageState()
                }
                self?.service.loadItemImage(url: detailsModel.imageUrl, handler: { [weak self] result in
                    switch(result) {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self?.viewInput?.setLoadedWithImageState(data: data)
                        }
                    case .failure(_):
                        DispatchQueue.main.async {
                            self?.viewInput?.setLoadedWithImageState(data: nil)
                        }
                    }
                })
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.viewInput?.setErrorState(error.localizedDescription)
                }
                print(error)
            }
        }
    }

}
