//
//  UITableView+Extension.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/06/09.
//

import UIKit

extension UITableView {
    func configureBaseCell<T: BaseCellProtocol>(
        value: T.Value) -> T where T: UITableViewCell {
        let cell: T = dequeReusableCell()
        cell.configure(with: value)
        return cell
    }
}
