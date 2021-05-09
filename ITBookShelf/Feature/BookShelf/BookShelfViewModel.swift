//
//  SearchViewModel.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import Foundation
import UIKit
import Combine

extension BookShlefViewController {
    class ViewModel {
        // MARK: - constant
        let error = PassthroughSubject<Error, Never>()
        // MARK: - varations
        @Published var books: [Model.Book] = []
        var selectedBookNumber: String = .empty
        // MARK: - private constants
        private let cancelables: Set<AnyCancellable> = Set()
        // MARK: - fetch data functions
        func fetchBooks() {
            guard let books = savedBooks(), books.count > .zero else {
                fetchNews()
                return
            }
            self.books = books
        }
        
        private func fetchNews() {
            Remote<Model.New>.lookup().asObservable()
            .compactMap({ $0 })
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
                self.books = $0.books
            }).cancel()
        }
        // MARK: - privae functions
        private func savedBooks() -> [Model.Book]? {
            guard let data = UserDefaults.standard.object(
                    forKey: BookShelfConstants.searchedBooksKey
            ) as? Data else {
              return []
            }
            return try? JSONDecoder().decode([Model.Book].self, from: data)
        }
    }
}
