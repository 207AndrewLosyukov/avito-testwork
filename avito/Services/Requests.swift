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

struct ItemsListResponse: Decodable {
    let items: [ItemResponse]

    enum CodingKeys: String, CodingKey {
        case items = "advertisements"
    }
}

struct ItemResponse: Decodable {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case price = "price"
        case location = "location"
        case imageUrl = "image_url"
        case createdDate = "created_date"
    }
}

struct ItemDetailsResponse: Decodable {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: String
    let description: String
    let email: String
    let phoneNumber: String
    let address: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case price = "price"
        case location = "location"
        case imageUrl = "image_url"
        case createdDate = "created_date"
        case description = "description"
        case email = "email"
        case phoneNumber = "phone_number"
        case address = "address"
    }
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
