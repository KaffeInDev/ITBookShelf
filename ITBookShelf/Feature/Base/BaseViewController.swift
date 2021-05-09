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
            .sink(receiveValue: {
                switch $0.name {
                case UIResponder.keyboardWillShowNotification:
                    var contentInset:UIEdgeInsets = scrollView.contentInset
                    contentInset.bottom = $0.keyboardHeight
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
    
    deinit {
        print("@@@ deinit \(self) @@@")
    }
}
