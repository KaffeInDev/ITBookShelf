//
//  SearchViewModel.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import UIKit
import CoreModular
import Combine

extension BookShlefViewController {
    class ViewModel {
        // MARK: - Lazy properties
        lazy var inputs: Inputs = { Inputs(base: self) }()
        lazy var outputs: Outputs = { Outputs(base: self) }()
        // MARK: - variables
        @Published var books: [Model.Book] = []
        // MARK: - private constants
        let cancelables: Set<AnyCancellable> = Set()
        let error = PassthroughSubject<Error, Never>()
        var selectedBookNumber: String = .empty
        // MARK: - fetch data functions
        func fetchBooks() {
            guard let books = savedBooks(), books.count > .zero else {
                fetchNews()
                return
            }
            self.books = books
        }
        
        func fetchNews() {
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
        func savedBooks() -> [Model.Book]? {
            guard let data = UserDefaults.standard.object(
                    forKey: BookShelfConstants.searchedBooksKey
            ) as? Data else {
              return []
            }
            return try? JSONDecoder().decode([Model.Book].self, from: data)
        }
    }
}

extension BookShlefViewController.ViewModel: ViewModelStream {
    typealias ViewModel = BookShlefViewController.ViewModel
    /// Implement only functions, if possible
    struct Inputs: ViewModelStreamInternals {
        private unowned var base: ViewModel
        init(base: ViewModel) { self.base = base }
    }
    /// Implement only functions, if possible
    struct Outputs: ViewModelStreamInternals {
        private unowned var base: ViewModel
        init(base: ViewModel) { self.base = base }
    }
}

fileprivate typealias Inputs = BookShlefViewController.ViewModel.Inputs
fileprivate typealias Outputs = BookShlefViewController.ViewModel.Outputs

extension Inputs {
    func fetchBooks() { base.fetchBooks() }
    func selectedBookNumber(_ number: String) { base.selectedBookNumber = number }
}

extension Outputs {
    var books: Published<[Model.Book]>.Publisher { base.$books }
    var booksValue: [Model.Book] { base.books }
    var error: PassthroughSubject<Error, Never> { base.error }
    var selectedBookNumber: String { base.selectedBookNumber }
}
