//
//  HasLet.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import Foundation

protocol HasLet { }

extension HasLet {
    func lets(closure: (Self) -> Void) {
        closure(self)
    }
}

extension NSObject: HasLet { }
