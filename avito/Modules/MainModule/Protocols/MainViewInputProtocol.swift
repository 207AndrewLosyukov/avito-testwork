//
//  MainViewInputProtocol.swift
//  avito
//
//  Created by Андрей Лосюков on 29.08.2023.
//

import Foundation

protocol MainViewInputProtocol: AnyObject {

    func updateSnapshot(with items: [ProductItem])

    func setLoading(enabled: Bool)
}
