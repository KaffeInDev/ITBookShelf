//
//  Notification+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/21.
//

import UIKit
import Combine

public extension Notification {
    var keyboardHeight: CGFloat {
        guard name == UIResponder.keyboardWillShowNotification else { return .zero }
        guard let userInfo = self.userInfo else { return .zero }
        guard let keyboardFrame =
                (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        else { return .zero }
        return keyboardFrame.size.height + 20
    }
}
