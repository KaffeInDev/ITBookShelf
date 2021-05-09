//
//  BaseCell.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import UIKit

protocol BaseCellProtocol {
    associatedtype Value
    func configure(with value: Value)
}

