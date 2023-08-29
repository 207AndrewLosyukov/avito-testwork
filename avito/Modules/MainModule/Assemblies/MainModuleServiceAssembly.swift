//
//  MainModuleServiceAssembly.swift
//  avito
//
//  Created by Андрей Лосюков on 29.08.2023.
//

import Foundation

final class MainModuleServiceAssembly {
    let itemLoaderService: ItemLoaderServiceProtocol

    init(itemLoaderService: ItemLoaderServiceProtocol) {
        self.itemLoaderService = itemLoaderService
    }
}
