//
//  UITableViewCell+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/23.
//

import UIKit

public extension UITableViewCell {
    static var reuseIdentifier: String { return "\(self.self)" }
    static func registerWithTableView(_ tableView: UITableView) {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: reuseIdentifier , bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
}
