//
//  UICollectionView+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/26.
//

import UIKit

public extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(type: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: type.reuseIdentifier , bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
