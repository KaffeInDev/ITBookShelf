//
//  String+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import UIKit

public extension String {
    static var empty: String { "" }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
    
    subscript(_ offset: Int) -> Character {
        self[index(self.startIndex, offsetBy: offset)]
    }
    
    func base64Encoded() -> String { Data(self.utf8).base64EncodedString() }
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func `repeat`(count: Int) -> Self { String(repeating: self, count: count) }
}
