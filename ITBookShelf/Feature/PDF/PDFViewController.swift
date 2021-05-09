//
//  PDFViewController.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/24.
//

import UIKit
import PDFKit
import Combine

class PDFViewController: UIViewController {
    var pdfView = PDFView()
    var viewModel = ViewModel()
    var cancelables: Set<AnyCancellable> = Set()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let url = viewModel.pdfURL else { return }
        startLoading()
        PDFDocument(url: url).publisher.compactMap { $0 }
        .subscribe(on: DispatchQueue.global())
        .receive(on: RunLoop.main)
        .sink(receiveValue: { [weak self] in
            self?.pdfView.document = $0
            self?.endLoading()
        }).store(in: &cancelables)
    }
    
    func configureViewModel(_ url: URL) {
        viewModel.pdfURL = url
    }
    
    private func configureSubViews() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor
        ).isActive = true
        pdfView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor
        ).isActive = true
        
        pdfView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44
        ).isActive = true
        
        pdfView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor
        ).isActive = true
        
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.interpolationQuality = .low
    }
}
