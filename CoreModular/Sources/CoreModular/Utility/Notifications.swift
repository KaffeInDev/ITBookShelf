//
//  Notifications.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/21.
//

import UIKit
import Combine

public struct Notifications {
    public typealias MergedNotificationPublusher =
        Publishers.Merge<NotificationCenter.Publisher, NotificationCenter.Publisher>
    public struct Keyboard {
        public static func willShownPublisher() -> NotificationCenter.Publisher {
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        }
        
        public static func willHidePublisher() -> NotificationCenter.Publisher {
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
        
        public static func mergedBehaviorPublishers() -> MergedNotificationPublusher {
            .init(willShownPublisher(), willHidePublisher())
        }
    }
}
