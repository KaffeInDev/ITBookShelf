//
//  GCD+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/22.
//

import Foundation

extension DispatchQueue {
    func safeAsync(_ block: @escaping () -> Void) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}
