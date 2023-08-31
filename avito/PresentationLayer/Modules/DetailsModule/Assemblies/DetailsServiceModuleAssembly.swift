//
//  DetailsServiceModuleAssembly.swift
//  avito
//
//  Created by Андрей Лосюков on 29.08.2023.
//

import Foundation

final class DetailsServiceModuleAssembly {
    let itemLoaderService: ItemLoaderServiceProtocol

    init(itemLoaderService: ItemLoaderServiceProtocol) {
        self.itemLoaderService = itemLoaderService
    }
}
