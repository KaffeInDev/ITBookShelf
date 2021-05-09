//
//  UITableView+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/24.
//

import UIKit
import Combine

public extension UITableView {    
    func dequeReusableCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Unable Deuque Reusable Cell")
        }
        return cell
    }
}
