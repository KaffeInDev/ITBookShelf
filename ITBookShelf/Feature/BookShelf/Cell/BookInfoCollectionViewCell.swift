//
//  BookInfoCollectionViewCell.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import UIKit
import Combine

class BookInfoCollectionViewCell: UICollectionViewCell, BaseCellProtocol {
    typealias Value = Model.Book
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLable: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    private var cancelable: AnyCancellable?
    private var model: Value?
    
    override func prepareForReuse() {
        titleLable.text = nil
        subtitleLabel.text = nil
        priceLabel.text = nil
        imageView.image = nil
        cancelable?.cancel()
    }
    
    func configure(with value: Value) {
        model = value
        titleLable.text = value.title
        subtitleLabel.text = value.subtitle.isEmpty ? "subtitle nothing" : value.subtitle
        priceLabel.text = value.price
        guard let imageURL = URL(string: value.image) else { return }
        cancelable?.cancel()
        cancelable = imageView.asyncImageCancelable(url: imageURL)
    }
}
