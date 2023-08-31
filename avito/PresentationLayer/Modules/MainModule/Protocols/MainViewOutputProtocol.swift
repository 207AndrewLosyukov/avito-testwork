//
//  MainViewOutputProtocol.swift
//  avito
//
//  Created by Андрей Лосюков on 29.08.2023.
//

import UIKit

protocol MainViewOutputProtocol {

    func loadItemsList()

    func configure(cell: ProductCell, index: Int)
    
    func openDetails(navigationController: UINavigationController?, withItemIndex index: Int)

}
