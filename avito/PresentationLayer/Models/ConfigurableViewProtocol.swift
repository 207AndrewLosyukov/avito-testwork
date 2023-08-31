//
//  ConfigurableViewProtocol.swift
//  avito
//
//  Created by Андрей Лосюков on 25.08.2023.
//

import Foundation

protocol ConfigurableViewProtocol {

    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}
