//
//  ProductCellModel.swift
//  avito
//
//  Created by Андрей Лосюков on 25.08.2023.
//

import UIKit

struct ProductCellModel: Hashable {
    let id: Int
    let title: String
    let price: String
    let location: String
    let url: String
    var image: UIImage?
    var isFetching: Bool = false
    let createdDate: String
}
