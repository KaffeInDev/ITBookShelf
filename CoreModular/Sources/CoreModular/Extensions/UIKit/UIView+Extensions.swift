//
//  UIView+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import UIKit

public protocol NibLoadableView: class {
    static var nibName: String { get }
}

public extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
    
    static func viewWithNib() -> Self {
        guard let view = UINib(nibName: nibName, bundle: nil)
                .instantiate(withOwner: nil, options: nil)[0] as? Self else {
            fatalError("Could not instantiate view with name: \(nibName)")
        }
        return view
    }
}

extension UIView: NibLoadableView {}
