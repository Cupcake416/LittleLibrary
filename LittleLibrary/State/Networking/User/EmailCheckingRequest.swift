//
//  EmailCheckingRequest.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/26.
//

import Foundation
import Combine

struct EmailCheckingRequest {
    let email: String

    var publisher: AnyPublisher<Bool, Never> {
        Future<Bool, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                if self.email.lowercased() == "onevcat@gmail.com" {
                    promise(.success(false))
                } else {
                    promise(.success(true))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
