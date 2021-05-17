//
//  LoadBookRequest.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/27.
//

import Foundation
import Combine

struct LoadBookRequest {
    let id: Int
    
    static var all: AnyPublisher<[BookViewModel], AppError> {
        return (1...4)
            .map { LoadBookRequest(id: $0).publisher }
            .zipAll
    }
    
    var publisher: AnyPublisher<BookViewModel, AppError> {
        BookPublisher(id)
            .map{ BookViewModel(book: $0) }
            .mapError{ AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    private func BookPublisher(_ id: Int) -> AnyPublisher<Book, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "http://10.79.24.116/api/books/\(id)/")!)
            .map{ $0.data }
            .decode(type: Book.self, decoder: appDecoder)
            .eraseToAnyPublisher()
    }
}
