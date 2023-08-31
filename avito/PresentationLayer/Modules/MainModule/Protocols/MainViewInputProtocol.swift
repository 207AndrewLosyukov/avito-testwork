//
//  MainViewInputProtocol.swift
//  avito
//
//  Created by Андрей Лосюков on 29.08.2023.
//

import Foundation

protocol MainViewInputProtocol: AnyObject {

    func setLoadedState(with items: [ProductItem])

    func setErrorState(_ error: String)

    func setLoadingState()
    
    func updateLoadedState(with items: [ProductItem])
}
