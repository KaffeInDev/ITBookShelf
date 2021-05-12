//
//  ITBookShelfTests.swift
//  ITBookShelfTests
//
//  Created by JunKyung.Park on 2021/01/18.
//

import XCTest
import PDFKit
import Combine
import CoreModular
@testable import ITBookShelf

class ITBookShelfTests: XCTestCase {
    private var cancelables: Set<AnyCancellable> = Set()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBookShlefViewController() {
        var viewController = bookShelfViewController()
        XCTAssertNotNil(viewController)
        viewController = nil
        XCTAssertNil(viewController)
        XCTAssertNil(viewController?.cancelables)
    }
    
    func testSearchResultViewController() {
        var viewController = searchResultViewController()
        XCTAssertNotNil(viewController)
        viewController = nil
        XCTAssertNil(viewController)
        XCTAssertNil(viewController?.cancelables)
    }
    
    func testBookDeailViewController() {
        var viewController = bookDetailViewController()
        XCTAssertNotNil(viewController)
        viewController = nil
        XCTAssertNil(viewController)
        XCTAssertNil(viewController?.cancelables)
    }
    
    func testPDFViewController() {
        var viewController: PDFViewController? = pdfViewController()
        XCTAssertNotNil(viewController)
        viewController = nil
        XCTAssertNil(viewController)
        XCTAssertNil(viewController?.cancelables)
    }
    
    func testPDFDoucmentAsync() {
        let viewController = pdfViewController()
        guard let url = pdfURL(),
              var cancelables = viewController?.cancelables else {
            XCTFail()
            return
        }
        
        let expect = expectation(description: "PDF document Test")
        
        PDFDocument(url: url).publisher.compactMap { $0 }
        .receive(on: RunLoop.main)
        .sink(receiveValue: {
            XCTAssertNotNil($0)
            expect.fulfill()
            
        }).store(in: &cancelables)
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testRemoteURLComponents() {
        let remote = Remote<Model.New>.lookup()
        let component = remote.urlComponents
        let expactationValues = ["https", "api.itbook.store", "/1.0"]
        
        XCTAssertFalse(
            expactationValues.difference(
                from: [component.scheme, component.host, component.host].compactMap { $0 }
            ).isEmpty
        )
    }
    
    func testRemoteNewsLookupAsObservable() {
        let remote = Remote<Model.New>.lookup().asObservable(10)
        XCTAssertNotNil(remote)
        
        let expect = expectation(description: "Remote Async")
        remote.sink(receiveCompletion: {
            switch $0 {
            case .failure(_):
                XCTFail()
                expect.fulfill()
            case .finished: break
            }
        }, receiveValue: {
            XCTAssertNotNil($0)
            XCTAssertNotNil($0 as Model.New)
            expect.fulfill()
        }).cancel()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRemoteSearchBookAsObservable() {
        let remote = Remote<Model.Search>.search("swift").asObservable(10)
        XCTAssertNotNil(remote)
        
        let expect = expectation(description: "Remote Async")
        remote.sink(receiveCompletion: {
            switch $0 {
            case .failure(_):
                XCTFail()
                expect.fulfill()
            case .finished: break
            }
        }, receiveValue: {
            XCTAssertNotNil($0)
            XCTAssertNotNil($0 as Model.Search)
            expect.fulfill()
        }).cancel()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRemoteDeatilBookAsObservable() {
        let remote = Remote<Model.DetailBook>.information("9781617294136").asObservable(10)
        XCTAssertNotNil(remote)
        
        let expect = expectation(description: "Remote Async")
        remote.sink(receiveCompletion: {
            switch $0 {
            case .failure(_):
                XCTFail()
                expect.fulfill()
            case .finished: break
            }
        }, receiveValue: {
            XCTAssertNotNil($0)
            XCTAssertNotNil($0 as Model.DetailBook)
            expect.fulfill()
        }).cancel()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    private func bookShelfViewController() -> BookShlefViewController? {
        UIStoryboard.init(
            name: "Main",
            bundle: .main
        ).instantiateViewController(
            withIdentifier: "BookShlefViewController"
        ) as? BookShlefViewController
    }
    
    private func searchResultViewController() -> SearchResultViewController? {
        .init(
            nibName: "SearchResultViewController",
            bundle: .main
        )
    }
    
    private func bookDetailViewController() -> BookDeailViewController? {
        UIStoryboard.init(
            name: "Main",
            bundle: .main
        ).instantiateViewController(
            withIdentifier: "BookDeailViewController"
        ) as? BookDeailViewController
    }
    
    
    private func pdfViewController() -> PDFViewController? {
        .init(
            nibName: "PDFViewController",
            bundle: .main
        )
    }
    
    private func pdfURL() -> URL? {
        URL(string: "https://itbook.store/files/9781617294136/chapter2.pdf")
    }
}
