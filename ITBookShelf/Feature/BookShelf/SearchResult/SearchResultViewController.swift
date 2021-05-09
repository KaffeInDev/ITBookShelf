//
//  SearchResultViewController.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/21.
//

import UIKit

import UIKit
import Combine

class SearchResultViewController: BaseViewController {
    @IBOutlet private var collectionView: UICollectionView!
    var viewModel: ViewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        bindKeyboardNotify(collectionView)
        bindViewModel()
    }
    
    func bindViewModel() {
        Publishers.Merge(viewModel.$books, viewModel.$filteredBooks)
        .receive(on: RunLoop.main)
        .sink(receiveValue: { [unowned self] _ in
            self.endLoading()
            self.collectionView.reloadData()
        }).store(in: &cancelables)
        
        viewModel.error.receive(on: RunLoop.main)
        .compactMap { $0 as? ResultError }
        .sink(receiveValue: { [unowned self] in
            self.endLoading()
            let alert = UIAlertController(title: .empty, message: $0.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }).store(in: &cancelables)
    }
    
    func configureSubviews() {
        collectionView.registerCell(type: BookInfoCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
            
    func configure(publisher: inout Published<[Model.Book]>.Publisher, value: [Model.Book]) {
        viewModel.books = value
        viewModel.$books.assign(to: &publisher)
        viewModel.hasConfigured = true
    }
    
    func hasConfigured() -> Bool { viewModel.hasConfigured }
        
    func searchButtonDidClick() {
        startLoading(.clear)
        viewModel.page = 1
        viewModel.books = []
        viewModel.fetchSearchResult()
    }
}

extension SearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchKeyword = searchController.searchBar.text else { return }
        print("new input: \(searchKeyword)")
        viewModel.isInputing = true
        viewModel.searchText = searchKeyword
    }
}

extension SearchResultViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filteredBooks.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BookInfoCollectionViewCell.reuseIdentifier,
                for: indexPath
        ) as? BookInfoCollectionViewCell
        else { return .init() }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? BookInfoCollectionViewCell else { return }
        guard let book = viewModel.filteredBooks[safe: indexPath.row] else { return }
        cell.configure(with: book)
        guard indexPath.row == viewModel.filteredBooks.count - 1 else { return }
        guard viewModel.moreDataRequestable else { return }
        startLoading(.clear)
        viewModel.nextPage()
        viewModel.fetchSearchResult()
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let paddingSpace = BookShelfConstants.sectionInsets.left * (BookShelfConstants.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / BookShelfConstants.itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 65)
  }
  
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        BookShelfConstants.sectionInsets
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBookNumber = viewModel.filteredBooks[safe: indexPath.row]?.isbn13 else { return }
        guard let viewController = UIStoryboard.init(
            name: "Main",
            bundle: .main
        ).instantiateViewController(
            withIdentifier: "BookDeailViewController"
        ) as? BookDeailViewController
        else { return }
        viewController.configure(selectedBookNumber)
        presentingViewController?
        .navigationController?
        .present(viewController, animated: true, completion: nil)
    }
}
