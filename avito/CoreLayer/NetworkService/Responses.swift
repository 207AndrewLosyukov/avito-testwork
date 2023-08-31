//
//  Responses.swift
//  avito
//
//  Created by Андрей Лосюков on 31.08.2023.
//

import Foundation

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
        case id, title, price, location
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
        case id, title, price, location, description, email, address
        case imageUrl = "image_url"
        case createdDate = "created_date"
        case phoneNumber = "phone_number"
    }
}
