//
//  HTTPMethod.swift
//  iTunesSearch
//
//  Created by JunKyung.Park on 2020/06/26.
//  Copyright © 2020 CoffeDev. All rights reserved.
//

import Foundation

public enum HTTPMethod {
    case get
    case post
    case put
    case patch
    case delete
}

internal extension HTTPMethod {
    var stringValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
