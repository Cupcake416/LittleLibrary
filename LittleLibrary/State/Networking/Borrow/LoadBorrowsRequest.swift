//
//  LoadAllBooksRequest.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/27.
//

import Foundation
import Combine

struct LoadBorrowsRequest {
    let cid: Int
    
    var publisher: AnyPublisher<[Borrow], AppError> {
        BorrowPublisher()
            .mapError{ AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func BorrowPublisher() -> AnyPublisher<[Borrow], Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "http://10.79.24.116/api/borrows/\(cid)/")!)
            .map{ $0.data }
            .decode(type: Array<Borrow>.self, decoder: appDecoder)
            .eraseToAnyPublisher()
    }
}
