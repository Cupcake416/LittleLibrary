//
//  LoginRequest.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/26.
//

import Foundation
import Combine

struct LoginRequest {
    let email: String
    let password: String

    var publisher: AnyPublisher<User, AppError> {
        LoginPublisher()
            .map{ genUser(response: $0) }
            .mapError{ AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func genUser(response: LogResponse) -> User {
        if response.message == "登陆成功" {
            return User(email: email)
        }
        return User(email: "@fail")
    }
    
    private func LoginPublisher() -> AnyPublisher<LogResponse, Error> {
        let urlString = "http://10.79.24.116/api/login/"
        
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        var json = [String: Any]()
        json["username"] = email
        json["password"] = password
        
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
                .decode(type: LogResponse.self, decoder: appDecoder)
                .eraseToAnyPublisher()
        } catch {
        }
        
        fatalError()
    }
}
