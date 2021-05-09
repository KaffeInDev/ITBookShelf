//
//  UIImageView+Extensions.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import UIKit
import Combine

class UIImageView: UIKit.UIImageView {}

extension UIImageView {
    func asyncImageCancelable(url: URL) -> AnyCancellable {
        startLoading()
        return ImageLoader.shared.loadImage(from: url)
        .sink(receiveCompletion: { [weak self] in
            guard let self = self else { return }
            self.endLoading()
            switch $0 {
            case .failure(let error): print(error)
            case .finished: break
            }
        }, receiveValue: { [weak self] in
            guard let self = self else { return }
            self.image = $0
        })
    }
}
