//
//  Sample.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import Foundation

#if DEBUG

extension Book {
    static func sample(id: Int) -> Book {
        return FileHelper.loadBundledJSON(file: "book-\(id)")
    }
    
    static func mySample() -> Book {
        guard let url = Bundle.main.url(forResource: "book-1", withExtension: "json") else {
            fatalError("Resource not found")
        }
        let book = Book(id: 1, title: "百年孤独", press: "dfsd", year: 2021, author: "dsf", price: 123, total: 342, stock: 123)
        print(url)
        try? FileHelper.writeJSON(book, to: url)
        return book
    }
    
}

extension BookViewModel {
    static var all: [Int: BookViewModel]? = {
        Dictionary(uniqueKeysWithValues: (1...6).map {
            ($0, BookViewModel(book: Book.sample(id: $0)))
        })
    }()
    
    static func sample(id: Int) -> BookViewModel {
        let book = Book.sample(id: id)
        return BookViewModel(book: book)
    }
}

extension Card {
    static func sample(id: Int) -> Card {
        return FileHelper.loadBundledJSON(file: "card-\(id)")
    }
}

extension CardViewModel {
    static var all: [Int: CardViewModel] = {
        Dictionary(uniqueKeysWithValues: (1...4).map {
            ($0, CardViewModel(card: Card.sample(id: $0)))
        })
    }()
    
    static var all2: [CardViewModel] = {
        (1...4).map {
            sample(id: $0)
        }
    }()
    
    static func sample(id: Int) -> CardViewModel {
        let card = Card.sample(id: id)
        return CardViewModel(card: card)
    }
}

extension BorrowViewModel {
    static func all(id: Int) -> [BorrowViewModel] {
        return CardViewModel.sample(id: 1).borrows
    }
}
#endif
