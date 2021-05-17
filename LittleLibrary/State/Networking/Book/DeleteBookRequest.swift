//
//  EditBookRequest.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/28.
//

import Foundation
import Combine

struct DeleteBookRequest {
    let id: Int
    
    var publisher: AnyPublisher<Int, AppError> {
        DeleteBookPublisher()
            .map{ $0.message == "删除成功" ? id : -1 }
            .mapError{ AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func DeleteBookPublisher() -> AnyPublisher<LogResponse, Error> {
        let urlString = "http://10.79.24.116/api/books/\(id)/"
        
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        var json = [String: Any]()
        json["id"] = id
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: LogResponse.self, decoder: appDecoder)
                .eraseToAnyPublisher()
        } catch {
        }
        
        fatalError()
    }
}
