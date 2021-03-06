//
//  ViewController.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/18.
//

import UIKit
import CoreModular

class BookShlefViewController: BaseViewController {
    // MARK: - IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    // MARK: - Constant
    let viewModel: ViewModelType<ViewModel> = .init(ViewModel())
    // MARK: - variations
    var searchControllerReference: UISearchController { searchController }
    // MARK: - private variations
    private lazy var searchController = {
        UISearchController(searchResultsController:searchResultViewController)
    }()
    private lazy var searchResultViewController = {
        SearchResultViewController(
            nibName: "SearchResultViewController",
            bundle: .main
        )
    }()
    // MARK: - overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        bindViewModel()
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard viewModel.outputs.selectedBookNumber.isEmpty == false else { return }
        let bookDetailViewController =  segue.destination as? BookDeailViewController
        bookDetailViewController?.configure(viewModel.outputs.selectedBookNumber)
    }
    //MARK: - functions
    func bindViewModel() {
        startLoading(.clear)
        viewModel.inputs.fetchBooks()
        viewModel.outputs.books
        .receive(on: RunLoop.main)
        .sink(receiveValue: { [unowned self] _ in
            self.collectionView.reloadData()
            self.endLoading()
        }).store(in: &cancelables)
        
        bindError()
    }
    
    func bindError() {
        viewModel.outputs.error.receive(on: RunLoop.main)
        .compactMap { $0 as? ResultError }
        .sink(receiveValue: { [unowned self] in
            self.endLoading()
            
            let alert = UIAlertController(title: "", message: $0.message, preferredStyle: .alert)
            alert.addAction(self.errorAlertAction())
            self.present(alert, animated: true, completion: nil)
        }).store(in: &cancelables)
    }
    
    private func errorAlertAction() -> UIAlertAction {
        UIAlertAction(
            title: "OK",
            style: .default,
            handler: { [unowned self] _ in
                DispatchQueue.main.safeAsync {
                    self.startLoading()
                    self.viewModel.inputs.fetchBooks()
                }
            }
        )
    }
}

// MARK: - configuration
extension BookShlefViewController {
    func configureSubviews() {
        collectionView.registerCell(type: BookInfoCollectionViewCell.self)
        configureSearchController()
        bindKeyboardNotify(collectionView)
    }
    
    func configureSearchController() {
        searchControllerReference.lets {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "search"
            $0.searchBar.delegate = self
            $0.searchResultsUpdater = searchResultViewController
        }
        navigationItem.lets { [weak self] in
            guard let self = self else { return }
            $0.searchController = self.searchControllerReference
            $0.hidesSearchBarWhenScrolling = false
        }
        definesPresentationContext = true
    }
}
// MARK: - SearchBar releated
extension BookShlefViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard searchResultViewController.hasConfigured() == false else { return }
        var books = viewModel.outputs.books
        searchResultViewController.configure(publisher: &books, value: viewModel.outputs.booksValue)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultViewController.searchButtonDidClick()
    }
}
