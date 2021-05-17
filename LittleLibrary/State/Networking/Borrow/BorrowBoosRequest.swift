//
//  AddNewBookRequest.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/28.
//

import Foundation
import Combine

struct BorrowBookRequest {
    let borrow: Borrow
    
    var publisher: AnyPublisher<Borrow, AppError> {
        BorrowBoosPublisher()
            .mapError{ AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func BorrowBoosPublisher() -> AnyPublisher<Borrow, Error> {
        let urlString = "http://10.79.24.116/api/borrows/"
        
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        var json = [String: Any]()
        json["cid"] = borrow.cid
        json["bid"] = borrow.bid
        json["admin_name"] = borrow.adminName
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: Borrow.self, decoder: appDecoder)
                .eraseToAnyPublisher()
        } catch {
        }
        
        fatalError()
    }
}
