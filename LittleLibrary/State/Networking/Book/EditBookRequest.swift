//
//  EditBookRequest.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/28.
//

import Foundation
import Combine

struct EditBookRequest {
    let book: Book
    
    var publisher: AnyPublisher<BookViewModel, AppError> {
        EditBookPublisher()
            .map{ BookViewModel(book: $0) }
            .mapError{ AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func EditBookPublisher() -> AnyPublisher<Book, Error> {
        let urlString = "http://10.79.24.116/api/books/\(book.id)/"
        
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        var json = [String: Any]()
        json["title"] = book.title
        json["author"] = book.author
        json["press"] = book.press
        json["year"] = book.year
        json["price"] = book.price
        json["stock"] = book.stock
        json["total"] = book.total
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: Book.self, decoder: appDecoder)
                .eraseToAnyPublisher()
        } catch {
        }
        
        fatalError()
    }
}
