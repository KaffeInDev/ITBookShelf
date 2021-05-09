//
//  Notifications.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/21.
//

import UIKit
import Combine

struct Notifications {
    typealias MergedNotificationPublusher =
        Publishers.Merge<NotificationCenter.Publisher, NotificationCenter.Publisher>
    struct Keyboard {
        static func willShownPublisher() -> NotificationCenter.Publisher {
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        }
        
        static func willHidePublisher() -> NotificationCenter.Publisher {
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
        
        static func mergedBehaviorPublishers() -> MergedNotificationPublusher {
            .init(willShownPublisher(), willHidePublisher())
        }
    }
}
