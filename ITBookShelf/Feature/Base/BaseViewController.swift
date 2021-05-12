//
//  BaseViewController.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/21.
//

import UIKit
import Combine
import CoreModular

class BaseViewController: UIViewController {
    var cancelables: Set<AnyCancellable> = Set()
/**
     # You can set contentInset of scrollView when keyboard notification
     - Parameter container: UIFocusItemScrollableContainer(scrollable common protocol)
*/
    func bindKeyboardNotify(_ container: UIFocusItemScrollableContainer) {
        switch container {
        case let scrollView as UIScrollView:
            Notifications.Keyboard.mergedBehaviorPublishers()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] in
                switch $0.name {
                case UIResponder.keyboardWillShowNotification:
                    var contentInset:UIEdgeInsets = scrollView.contentInset
                    contentInset.bottom = self.keyboardHeight($0.userInfo)
                    scrollView.contentInset = contentInset
                case UIResponder.keyboardWillHideNotification:
                    scrollView.contentInset = .zero
                default:
                    break
                }
            }).store(in: &cancelables)
            break
        default:
            break
        }
    }
    
    private func keyboardHeight(_ userInfo: [AnyHashable : Any]?) -> CGFloat {
        guard let userInfo = userInfo else { return 0 }
        guard let keyboardFrame =
                userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        else { return .zero }
        return keyboardFrame.cgRectValue.size.height + 20
    }
    
    deinit {
        print("@@@ deinit \(self) @@@")
    }
}
