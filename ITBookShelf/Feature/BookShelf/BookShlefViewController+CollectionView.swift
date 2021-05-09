//
//  BookShlefViewController+CollectionView.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import UIKit

// MARK: - CollectionView releated
extension BookShlefViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BookInfoCollectionViewCell.reuseIdentifier,
                for: indexPath
        ) as? BookInfoCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        return cell
    }
        
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? BookInfoCollectionViewCell else { return }
        guard let books = viewModel.books[safe: indexPath.row] else { return }
        cell.configure(with: books)
    }
    // MARK: - action: didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedBookNumber = viewModel.books[indexPath.row].isbn13
        performSegue(withIdentifier: "showBookDetail", sender: self)
    }
}
// MARK: - collectionView layouts
extension BookShlefViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let paddingSpace = BookShelfConstants.sectionInsets.left * (BookShelfConstants.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / BookShelfConstants.itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + BookShelfConstants.addtionalCellHeight)
  }
  
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        BookShelfConstants.sectionInsets
        
    }
  
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        BookShelfConstants.sectionInsets.left
        
    }
}
