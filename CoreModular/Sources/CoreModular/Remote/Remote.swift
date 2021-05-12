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
    public lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.itbook.store"
        components.path = "/1.0"
        return components
    }()
    
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    private let session: URLSession = .init(configuration: .default)
    private var parameters: [URLQueryItem]? = nil
    private var method: HTTPMethod = .get
    public init(_ path: String? = nil, parameters: [URLQueryItem]? = nil, method: HTTPMethod = .get) {
        self.method = method
        if method == .get {
            urlComponents.queryItems = parameters
        }
        self.parameters = parameters
        if let path = path {
            urlComponents.path = path
        }
    }
}

public extension Remote {
    func asObservable(_ timeout: TimeInterval = 10) -> AnyPublisher<T, Error> {
        urlComponents.url.publisher.mapError({ _ in URLError(.badURL) })
        .tryCompactMap { [unowned self] in
            try Request.make(url: $0, method: self.method, parameters: self.parameters)
        }.flatMap({ [unowned self] in
            self.session.dataTaskPublisher(for: $0, cachedResponseOnError: true)
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

fileprivate struct Request {
    static func make(
        url: URL,
        method: HTTPMethod,
        parameters: [URLQueryItem]?) throws -> URLRequest {
        var request = URLRequest(url: url)
        if method != .get {
            request.httpBody = try HTTPBody.make(parameters)
        }
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

fileprivate class HTTPBody {
    static func make(_ parameters: [URLQueryItem]?) throws -> Data? {
        guard let parameters = parameters else { return nil }
        do {
            return try JSONSerialization.data(
                withJSONObject: parameters,
                options: .prettyPrinted
            )
        } catch {
            throw ResultError.jsonEncodingFailed
        }
    }
}
