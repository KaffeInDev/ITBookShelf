//
//  Model+Remote.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import Foundation
import CoreModular

protocol BookShelf: Codable {
    var total: String { get }
    var error: String { get }
    var books: [Model.Book] { get }
}

extension BookShelf {
    func searchBooks(_ keyword: String) -> [Model.Book] {
        books.filter {
            $0.title.lowercased().contains(keyword) ||
            $0.subtitle.lowercased().contains(keyword) ||
            $0.price.lowercased().contains(keyword)
        }
    }
}

protocol BookInfo: Codable & Equatable {
    var title: String { get }
    var subtitle: String { get }
    var isbn13: String { get }
    var price: String { get }
    var image: String { get }
    var url: String { get }
}

extension BookInfo {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.isbn13 == rhs.isbn13
    }
}

struct Model: Codable {}

extension Model {
    struct New: BookShelf {
        var total: String
        var error: String
        var books: [Model.Book]
    }
    
    struct Search: BookShelf {
        var total: String
        var error: String
        var books: [Model.Book]
        var page: String
    }
    
    struct Book: BookInfo, Equatable {
        var title: String
        var subtitle: String
        var isbn13: String
        var price: String
        var image: String 
        var url: String
    }
    
    struct DetailBook: BookInfo {
        var title: String
        var subtitle: String
        var isbn13: String
        var price: String
        var image: String
        var url: String
        
        var error: String
        var pages: String
        var year: String
        var rating: String
        var desc: String
        var authors: String
        var publisher: String
        var isbn10: String
        var pdf: [String: String]?
    }
}


extension Remote where T == Model.New {
    static func lookup() -> Remote {
        let instance = Remote(parameters: [] ,method: .get)
        instance.urlComponent.path = "/1.0/new"
        return instance
    }
}

extension Remote where T == Model.DetailBook {
    static func information(_ isbn13: String) -> Remote {
        let instance = Remote(parameters: [] ,method: .get)
        instance.urlComponent.path = "/1.0/books/\(isbn13)"
        return instance
    }
}

extension Remote where T == Model.Search {
    private static var defaultPage: Int { get { 1 } }
    static func search(_ keyword: String, page: Int = defaultPage) -> Remote {
        let instance = Remote(parameters: [] ,method: .get)
        instance.urlComponent.path = "/1.0/search/\(keyword)/\(page)"
        return instance
    }
}
