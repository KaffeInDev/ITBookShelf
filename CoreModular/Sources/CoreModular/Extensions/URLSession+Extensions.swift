//
//  URLSession+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/26.
//

import Foundation
import Combine

public extension URLSession {
    typealias PublisherOutPut = URLSession.DataTaskPublisher.Output
    /// ## you can get dataTaskPublisher for using cached response when error.
    /// - Parameters:
    ///     - url: URL
    ///     - cachedResponseOnError: using cached response on error flag
    /// - Returns: AnyPublisher<URLSession.DataTaskPublisher.Output, Error>
    func dataTaskPublisher(for url: URL,
                           cachedResponseOnError: Bool = false) -> AnyPublisher<PublisherOutPut, Error> {
        
        dataTaskPublisher(for: url)
            .tryCatch { [weak self] (error) -> AnyPublisher<PublisherOutPut, Never> in
                guard cachedResponseOnError,
                    let urlCache = self?.configuration.urlCache,
                    let cachedResponse = urlCache.cachedResponse(for: URLRequest(url: url))
                else { throw error }
                return Just(PublisherOutPut(
                    data: cachedResponse.data,
                    response: cachedResponse.response
                )).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
