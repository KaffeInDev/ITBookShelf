//
//  String+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import Foundation

extension String {
    static var empty: String { "" }
    
    func base64Encoded() -> String { Data(self.utf8).base64EncodedString() }
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}


