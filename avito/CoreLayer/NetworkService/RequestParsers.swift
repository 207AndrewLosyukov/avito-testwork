//
//  RequestParsers.swift
//  avito
//
//  Created by Андрей Лосюков on 24.08.2023.
//

import Foundation

protocol ResponseParserProtocol {
    associatedtype Model
    func parse(data: Data) -> Model?
}

class AdditionalDecoder<Model: Decodable>: ResponseParserProtocol {

    func parse(data: Data) -> Model? {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(Model.self, from: data)
        return model
    }
}

class DefaultDecoder: ResponseParserProtocol {
    func parse(data: Data) -> Data? {
        return data
    }
}
