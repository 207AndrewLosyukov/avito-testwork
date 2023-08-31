//
//  DetailsViewInputProtocol.swift
//  avito
//
//  Created by Андрей Лосюков on 29.08.2023.
//

import Foundation

protocol DetailsViewInputProtocol: AnyObject {

    func setLoadedWithoutImageState(detailsModel: ItemDetailsResponse)

    func setLoadedWithImageState(data: Data?)

    func setErrorState(_ error: String)

    func setLoadingWithoutImageState()

    func setLoadingWithImageState()
}
