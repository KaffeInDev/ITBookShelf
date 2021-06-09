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

protocol BaseCellModelProtocol {
    var cellIdentifier: UITableViewCell.Type { get }
}

class BaseCell: UITableViewCell, BaseCellProtocol {
    typealias Value = BaseCellModelProtocol
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    /// Should be override func if needed
    func configure(with value: Value) {}
}

