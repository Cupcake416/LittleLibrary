//
//  LoadAllBooksRequest.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/27.
//

import Foundation
import Combine

struct LoadAllBookRequest {
    static var all: AnyPublisher<[BookViewModel], AppError> {
        return LoadAllBookRequest().publisher
    }
    
    var publisher: AnyPublisher<[BookViewModel], AppError> {
        BookPublisher()
            .map{
                $0.map{
                    BookViewModel(book: $0)
                }
            }
            .mapError{ AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    private func BookPublisher() -> AnyPublisher<[Book], Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "http://10.79.24.116/api/books/")!)
            .map{ $0.data }
            .decode(type: Array<Book>.self, decoder: appDecoder)
            .eraseToAnyPublisher()
    }
}
