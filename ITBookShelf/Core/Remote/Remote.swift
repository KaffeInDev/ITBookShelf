//
//  Remote.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/18.
//

import Foundation
import Combine
import UIKit

class Remote<T: Codable> {
    fileprivate lazy var urlComponent: URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.itbook.store"
        component.path = "/1.0"
        return component
    }()
    
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    #if DEBUG
    internal var debugURLComponent: URLComponents { urlComponent }
    #endif
    
    private let session: URLSession = .init(configuration: .default)
    private var method: HTTPMethod
    private var parameters: [URLQueryItem] = []
    
    init(_ path: String? = nil, parameters: [URLQueryItem] = [], method: HTTPMethod = .get) {
        self.method = method
        urlComponent.queryItems = parameters
        if let path = path {
            urlComponent.path = path
        }
    }
}

extension Remote {
    func asObservable(_ timeout: TimeInterval = 10) -> AnyPublisher<T, Error> {
        urlComponent.url.publisher.mapError({ _ in URLError(.badURL) })
        .flatMap({
            URLSession.shared.dataTaskPublisher(for: $0, cachedResponseOnError: true)
        }).tryMap { data, response -> Data in
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                throw ResultError.invalidStatusCode
            }
            return data
        }.timeout(.seconds(timeout), scheduler: RunLoop.main, customError: { ResultError.timeout })
        .decode(type: T.self, decoder: JSONDecoder())
        .subscribe(on: backgroundQueue)
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}

extension Remote where T == Model.New {
    static func lookup() -> Remote {
        let instance = Remote(parameters: [] ,method: .get)
        instance.urlComponent.path = "/1.0/new"
        return instance
    }
}

extension Remote where T == Model.DetailBook {
    static func information(_ isbn13: String) -> Remote {
        let instance = Remote(parameters: [] ,method: .get)
        instance.urlComponent.path = "/1.0/books/\(isbn13)"
        return instance
    }
}

extension Remote where T == Model.Search {
    private static var defaultPage: Int { get { 1 } }
    static func search(_ keyword: String, page: Int = defaultPage) -> Remote {
        let instance = Remote(parameters: [] ,method: .get)
        instance.urlComponent.path = "/1.0/search/\(keyword)/\(page)"
        return instance
    }
}
