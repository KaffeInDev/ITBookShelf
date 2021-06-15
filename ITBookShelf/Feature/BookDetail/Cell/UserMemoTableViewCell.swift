//
//  UserMemoTableViewCell.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/23.
//

import UIKit
import CoreModular

class UserMemoTableViewCell: UITableViewCell, BaseCellProtocol {
    typealias Value = Model.DetailBook
    @IBOutlet private var textView: UITextView!
    private var model: Value?
    private var debounceTimer: Timer?
    
    func configure(with value: Value) {
        textView.delegate = self
        model = value
        guard let memo = savedMemo() else { return }
        textView.text = memo
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = nil
    }
}

extension UserMemoTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text, text.isEmpty == false else { return }
        saveMemo(text)
    }
}

extension UserMemoTableViewCell: UserDefaultsCodable {
    private func savedMemo() -> String? {
        return try? userDefaultsDecode(key: memoKey())
    }
    
    private func saveMemo(_ text: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer
        .scheduledTimer(
            withTimeInterval: 0.5,
            repeats: false
        ) { [unowned self] _ in
            try? self.userDefaultsEncode(key: self.memoKey())
        }
    }
    
    private func memoKey() -> String {
        guard let model = model else {return .empty }
        return (BookShelfConstants.savedMemoKey + model.isbn13).base64Encoded()
    }
}
