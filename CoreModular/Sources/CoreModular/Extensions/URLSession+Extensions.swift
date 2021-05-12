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
    ///     - request: URLRequest
    ///     - cachedResponseOnError: using cached response on error flag
    /// - Returns: AnyPublisher<URLSession.DataTaskPublisher.Output, Error>
    func dataTaskPublisher(for request: URLRequest,
                          cachedResponseOnError: Bool = false) -> AnyPublisher<PublisherOutPut, Error> {
        dataTaskPublisher(for: request)
            .tryCatch { [weak self] (error) -> AnyPublisher<PublisherOutPut, Never> in
                guard cachedResponseOnError,
                    let urlCache = self?.configuration.urlCache,
                    let cachedResponse = urlCache.cachedResponse(for: request)
                else { throw error }
                return Just(PublisherOutPut(
                    data: cachedResponse.data,
                    response: cachedResponse.response
                )).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
