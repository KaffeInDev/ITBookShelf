//
//  Range+Extensions.swift
//  
//
//  Created by JunKyung.Park on 2021/05/13.
//

import Foundation

extension Range where Bound: BinaryInteger {
    var nsRange: NSRange {
        NSMakeRange(startIndex, endIndex)
    }
}
