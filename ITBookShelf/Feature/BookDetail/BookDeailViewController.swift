//
//  BookDeailViewController.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/23.
//

import UIKit

class BookDeailViewController: BaseViewController {
    enum Constants { static let cellCount = 2 }
    enum TableViewRows: Int {
        case information = 0
        case userMemo
        case pdf
    }
    
    @IBOutlet private var tableView: UITableView!
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        bindViewModel()
        startLoading(.clear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func bindViewModel() {
        viewModel.fetchBookDetail()
        viewModel.$book.receive(on: RunLoop.main)
        .sink(receiveValue: { [unowned self] _ in
            self.tableView.reloadData()
            self.endLoading()
        }).store(in: &cancelables)
        
        viewModel.error.receive(on: RunLoop.main)
        .sink(receiveValue: { [unowned self] in
            self.endLoading()
            let alert = UIAlertController(title: "", message: $0.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }).store(in: &cancelables)
    }
    
    func configureSubviews() {
        bindKeyboardNotify(tableView)
        Notifications.Keyboard.willShownPublisher()
        .receive(on: RunLoop.main)
        .sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.scrollToRow(
                at: IndexPath(row: TableViewRows.userMemo.rawValue, section: .zero),
                at: .bottom, animated: true
            )
        }).store(in: &cancelables)
    }
    
    func configure(_ isbn13: String) { viewModel.configure(isbn13) }
}
// MARK: - tableview delegate, datasource
extension BookDeailViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row >= TableViewRows.pdf.rawValue else { return }
        let pdfViewController = PDFViewController(
            nibName: "PDFViewController",
            bundle: .main
        )
        let pdfIndex = indexPath.row - TableViewRows.pdf.rawValue
        guard let values = viewModel.book?.pdf?.map({ $0.value }).sorted() else { return }
        guard let urlString = values[safe: pdfIndex], let url = URL(string: urlString) else { return }
        pdfViewController.configureViewModel(url)
        present(pdfViewController, animated: true, completion: nil)
    }
}

extension BookDeailViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.cellCount + (viewModel.book?.pdf?.values.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        guard let book = viewModel.book else { return cell }
        switch TableViewRows(rawValue: indexPath.row) {
        case .information:
            let detailInfoCell: BookDeatilInfoTableViewCell = tableView.dequeReusableCell()
            detailInfoCell.configure(with: book)
            cell = detailInfoCell
        case .userMemo:
            let userMemoCell: UserMemoTableViewCell = tableView.dequeReusableCell()
            userMemoCell.configure(with: book)
            cell = userMemoCell
        case _ where (TableViewRows.pdf.rawValue...).contains(indexPath.row):
            cell = tableView.dequeueReusableCell(withIdentifier: "PDF", for: indexPath)
            let pdfIndex = indexPath.row - TableViewRows.pdf.rawValue
            guard let keys = viewModel.book?.pdf?.map({ $0.key }).sorted() else { return cell }
            cell.textLabel?.text = "PDF Sample: " + (keys[safe: pdfIndex] ?? .empty)
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
}
