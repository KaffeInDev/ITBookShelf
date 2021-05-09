//
//  SearchResultViewModel.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/21.
//

import UIKit
import CoreModular
import Combine

extension SearchResultViewController {
    class ViewModel {
        let error = PassthroughSubject<Error, Never>()
        @Published var books: [Model.Book] = []
        @Published var filteredBooks: [Model.Book] = []
        @Published var searchText: String = ""
        
        var totalBooksCount: Int = .zero
        
        var hasConfigured = false
        var isInputing = false
        var page = 1
        var moreDataRequestable: Bool {
            isLoading == false &&
            isInputing == false &&
            books.count < totalBooksCount
        }
        
        private var isLoading = false
        private var cancelables: Set<AnyCancellable> = Set()
        
        
        init() {
            $searchText.receive(on: RunLoop.main)
            .filter { $0.isEmpty == false }
            .map { $0.lowercased() }
            .map { [unowned self] text -> [Model.Book] in
                return self.books
                    .filter {
                        $0.title.lowercased().contains(text) ||
                        $0.subtitle.lowercased().contains(text) ||
                        $0.price.lowercased().contains(text)
                    }
            }.assign(to: &$filteredBooks)
        }
        
        func fetchSearchResult() {
            guard searchText.isEmpty == false else { return }
            isInputing = false
            Remote<Model.Search>.search(searchText, page: page).asObservable()
            .compactMap({ $0 })
            .sink(receiveCompletion: { [unowned self] in
                switch $0 {
                case .failure(let error):
                    self.error.send(error as Error)
                    print(error)
                case .finished: print($0)
                }
                isLoading = false
            }, receiveValue: { [unowned self] in
                print("new receiveValue")
                print($0)
                isLoading = false
                self.totalBooksCount = Int($0.total) ?? .zero
                self.books += $0.books
                self.filteredBooks = self.books
                
                try? UserDefaults.standard.set(
                    JSONEncoder().encode(self.books),
                    forKey:BookShelfConstants.searchedBooksKey
                )
            }).cancel()
        }
        
        func nextPage() { isLoading = true; page += 1 }
    }
}
