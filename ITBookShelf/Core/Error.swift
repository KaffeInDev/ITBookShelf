//
//  Error.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/21.
//

import Foundation

enum ResultError: Error {
    case dataIsNil
    case invalidStatusCode
    case timeout
    case error(Error)
    case message(String)
    case none
}

extension ResultError {
    var message: String {
        switch self {
        case .dataIsNil: return "no data"
        case .invalidStatusCode: return "server side invalidate"
        case .timeout: return "request time out, try again"
        case .message(let errorMessage): return errorMessage
        case .none: return "this is not a error"
        default: return .empty
        }
    }
}
