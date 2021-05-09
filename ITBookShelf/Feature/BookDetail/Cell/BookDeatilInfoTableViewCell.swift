//
//  BookDeatilInfoTableViewCell.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/23.
//

import UIKit
import Combine

class BookDeatilInfoTableViewCell: UITableViewCell, BaseCellProtocol {
    typealias Value = Model.DetailBook
    
    @IBOutlet private var bookImageView: UIImageView!
    @IBOutlet private var textLabels: [UILabel]!
    @IBOutlet weak var urlTextView: UITextView!
    private var cancelable: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        zip(textLabels, TextLabelsTag.allCases)
        .forEach({ $0.0.tag = $0.1.rawValue })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image = nil
        textLabels.forEach({ $0.text = nil })
        urlTextView.text = nil
        cancelable?.cancel()
    }
    
    func configure(with value: Value) {
        mapTextLables(value)
        urlTextView.text = value.url
        
        guard let imageURL = URL(string: value.image) else { return }
        cancelable?.cancel()
        cancelable = bookImageView.asyncImageCancelable(url: imageURL)
    }
    
    func mapTextLables(_ value: Value) {
        let values = [
            value.title,
            value.subtitle,
            value.authors,
            value.publisher,
            value.pages,
            value.year,
            value.rating,
            value.desc,
            value.price
        ]
        
        let titles = zip(TextLabelsTag.allCases, values).map { $0.0.title + $0.1 }
        zip(textLabels, titles).forEach { $0.0.text = $0.1 }
    }
}

extension BookDeatilInfoTableViewCell {
    enum TextLabelsTag: Int, CaseIterable {
        case title = 0, subtitle, authors, publisher, pages, year, rating, desc, price
    }
}

extension BookDeatilInfoTableViewCell.TextLabelsTag {
    var title: String {
        switch self {
        case .title: return "title: "
        case .subtitle: return "subtitle: "
        case .authors: return "authors: "
        case .publisher: return "publisher: "
        case .pages: return "pages: "
        case .year: return "year: "
        case .rating: return "rating: "
        case .desc: return "desc: "
        case .price: return "price: "
        
        }
    }
}
