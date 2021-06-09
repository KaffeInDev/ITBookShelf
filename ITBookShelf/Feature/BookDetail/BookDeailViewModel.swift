//
//  BookDeailViewModel.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/23.
//

import UIKit
import CoreModular
import Combine

extension BookDeailViewController {
    class ViewModel {
        // MARK: - Lazy properties
        lazy var inputs: Inputs = { Inputs(base: self) }()
        lazy var outputs: Outputs = { Outputs(base: self) }()
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
    }
}

extension BookDeailViewController.ViewModel: ViewModelStream {
    typealias ViewModel = BookDeailViewController.ViewModel
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

extension BookDeailViewController.ViewModel.Inputs: DependancyConfigurable {
    typealias Dependancy = String
    func configure(_ dependancy: Dependancy) {
        base.isbn13 = dependancy
    }
    func fetchBookDetail() { base.fetchBookDetail() }
}

extension BookDeailViewController.ViewModel.Outputs {
    // FIXME: - We need 'Publisehd' change to CurrentValueSubject
    var book: Published<Model.DetailBook?>.Publisher { base.$book }
    var bookValue: Model.DetailBook? { base.book }
    var error: PassthroughSubject<Error, Never> { base.error }
}

