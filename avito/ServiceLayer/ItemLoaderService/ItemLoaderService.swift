//
//  ItemLoaderService.swift
//  avito
//
//  Created by Андрей Лосюков on 24.08.2023.
//

import UIKit

class ItemLoaderService: ItemLoaderServiceProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func loadItemsList(handler: @escaping((Result<[ItemResponse], Error>) -> Void)) {
        networkService.fetch(request: ItemsListRequest(),
                            parser: AdditionalDecoder<ItemsListResponse>()) { result in
            switch result {
            case .success(let searchResponse):
                handler(.success(searchResponse.items))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    func loadItemImage(url: String, handler: @escaping ((Result<Data, Error>) -> Void)) {
        networkService.fetch(request: ItemImageRequest(url: url),
                            parser: DefaultDecoder()) { result in
            switch result {
            case .success(let data):
                handler(.success(data))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    func loadItemDetails(id: Int, handler: @escaping ((Result<ItemDetailsResponse, Error>) -> Void)) {
        networkService.fetch(request: ItemDetailsRequest(id: id),
                            parser: AdditionalDecoder<ItemDetailsResponse>()) { result in
            switch result {
            case .success(let searchResponse):
                handler(.success(searchResponse))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
