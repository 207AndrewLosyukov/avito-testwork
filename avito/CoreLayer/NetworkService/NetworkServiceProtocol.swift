//
//  NetworkServiceProtocol.swift
//  avito
//
//  Created by Андрей Лосюков on 24.08.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    
    var session: URLSession { get }

    func fetch<Model, Parser>(request: RequestProtocol, parser: Parser,
                              handler: @escaping(Result<Model, Error>) -> Void)
    where Parser: ResponseParserProtocol, Parser.Model == Model
}
