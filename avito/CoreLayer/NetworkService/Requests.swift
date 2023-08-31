//
//  Requests.swift
//  avito
//
//  Created by Андрей Лосюков on 24.08.2023.
//

import Foundation

protocol RequestProtocol {
    var urlRequest: URLRequest? { get }
}

class ItemImageRequest: RequestProtocol {

    var urlRequest: URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    }

    let url: String

    init(url: String) {
        self.url = url
    }
}

class ItemsListRequest: RequestProtocol {

    var urlRequest: URLRequest? {
        guard let url = URL(string: "https://www.avito.st/s/interns-ios/main-page.json") else {
            return nil
        }
        return URLRequest(url: url)
    }

    init() {
    }
}

class ItemDetailsRequest: RequestProtocol {
    var urlRequest: URLRequest? {
        guard let url = URL(string: "https://www.avito.st/s/interns-ios/details/\(id).json") else {
            return nil
        }
        return URLRequest(url: url)
    }

    private let id: Int

    init(id: Int) {
        self.id = id
    }
}
