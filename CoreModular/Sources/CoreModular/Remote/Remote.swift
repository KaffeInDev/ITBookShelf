//
//  Remote.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/18.
//

import Foundation
import Combine
import UIKit

open class Remote<T: Codable> {
    public lazy var urlComponent: URLComponents = {
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
    
    private let session: URLSession = .init(configuration: .default)
    private var method: HTTPMethod
    private var parameters: [URLQueryItem] = []
    
    public init(_ path: String? = nil, parameters: [URLQueryItem] = [], method: HTTPMethod = .get) {
        self.method = method
        urlComponent.queryItems = parameters
        if let path = path {
            urlComponent.path = path
        }
    }
}

public extension Remote {
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

