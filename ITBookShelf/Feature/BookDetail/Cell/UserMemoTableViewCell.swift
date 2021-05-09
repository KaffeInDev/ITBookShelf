//
//  UserMemoTableViewCell.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/23.
//

import UIKit

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
    
    func savedMemo() -> String? {
        guard let model = model else {return nil }
        guard let data = UserDefaults.standard.object(
            forKey: (BookShelfConstants.savedMemoKey + model.isbn13).base64Encoded()
        ) as? Data else {
            return .empty
        }
        return try? JSONDecoder().decode(String.self, from: data)
    }
    
    func saveMemo(_ text: String) {
        guard let model = self.model else { return }
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            try? UserDefaults.standard.set(
                JSONEncoder().encode(text),
                forKey: (BookShelfConstants.savedMemoKey + model.isbn13).base64Encoded()
            )
        }
    }
}
