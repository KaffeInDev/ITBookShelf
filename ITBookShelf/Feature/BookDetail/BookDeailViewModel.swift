//
//  BookDeailViewModel.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/23.
//

import UIKit
import Combine

extension BookDeailViewController {
    class ViewModel {
        let error = PassthroughSubject<Error, Never>()
        var cancelables: Set<AnyCancellable> = Set()
        @Published var book: Model.DetailBook?
        private var isbn13: String = ""
        
        func fetchBookDetail() {
            guard isbn13.isEmpty == false else {
                error.send(ResultError.dataIsNil)
                return
            }
            Remote<Model.DetailBook>.information(isbn13).asObservable()
            .compactMap { $0 }
            .sink(receiveCompletion: { [unowned self] in
                switch $0 {
                case .failure(let error):
                    print(error)
                    self.error.send(error as Error)
                case .finished: print($0)
                }
            }, receiveValue: { [unowned self] in
                print("new receiveValue")
                print($0)
                self.book = $0
            }).store(in: &cancelables)
        }
        
        func configure(_ isbn13: String) { self.isbn13 = isbn13 }
    }
}
