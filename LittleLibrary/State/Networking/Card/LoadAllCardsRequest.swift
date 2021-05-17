//
//  LoadAllBooksRequest.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/27.
//

import Foundation
import Combine

struct LoadAllCardRequest {
    static var all: AnyPublisher<[CardViewModel], AppError> {
        return LoadAllCardRequest().publisher
    }
    
    var publisher: AnyPublisher<[CardViewModel], AppError> {
        CardPublisher()
            .map{
                $0.map{
                    CardViewModel(card: $0)
                }
            }
            .mapError{ AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    private func CardPublisher() -> AnyPublisher<[Card], Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "http://10.79.24.116/api/cards/")!)
            .map{ $0.data }
            .decode(type: Array<Card>.self, decoder: appDecoder)
            .eraseToAnyPublisher()
    }
}
