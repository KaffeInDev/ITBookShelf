//
//  Array+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/21.
//

import Foundation

extension Array where Element: Equatable {
    /// ## you can get element of index in array as safely.
    /// - Parameters:
    ///     - index: element index
    /// - Returns: optional Element
    subscript(safe index: Int) -> Element? { indices ~= index ? self[index] : nil }
}
