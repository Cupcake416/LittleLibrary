//
//  AddNewBookRequest.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/28.
//

import Foundation
import Combine

struct AddNewCardRequest {
    let card: Card
    
    var publisher: AnyPublisher<CardViewModel, AppError> {
        AddNewCardPublisher()
            .map{ CardViewModel(card: $0) }
            .mapError{ AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func AddNewCardPublisher() -> AnyPublisher<Card, Error> {
        let urlString = "http://10.79.24.116/api/cards/"
        
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        var json = [String: Any]()
        json["name"] = card.name
        json["unit"] = card.unit
        json["ctype"] = card.ctype.rawValue
        
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
                .decode(type: Card.self, decoder: appDecoder)
                .eraseToAnyPublisher()
        } catch {
        }
        
        fatalError()
    }
}
