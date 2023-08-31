//
//  ItemLoaderServiceProtocol.swift
//  avito
//
//  Created by Андрей Лосюков on 24.08.2023.
//

import Foundation

protocol ItemLoaderServiceProtocol {

    func loadItemsList(handler: @escaping((Result<[ItemResponse], Error>) -> Void))

    func loadItemImage(url: String, handler: @escaping ((Result<Data, Error>) -> Void))

    func loadItemDetails(id: Int, handler: @escaping ((Result<ItemDetailsResponse, Error>) -> Void))
}
