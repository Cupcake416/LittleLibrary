//
//  UserInfoAppState.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/5/8.
//

import Foundation
import Combine

extension AppState {
    struct UserInfo {
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        
        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""

            var isEmailValid: AnyPublisher<Bool, Never> {

                let emailLocalValid = $email.map { $0.isValidEmailAddress }
                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }
                let remoteVerify = $email
                    .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        switch (validEmail, canSkip) {
                        case (false, _):
                            return Just(false).eraseToAnyPublisher()
                        case (true, false):
                            return EmailCheckingRequest(email: email)
                                .publisher
                                .eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                    }
                return Publishers.CombineLatest3(
                        emailLocalValid, canSkipRemoteVerify, remoteVerify
                    )
                    .map { $0 && ($1 || $2) }
                    .eraseToAnyPublisher()
            }

            var isValid: AnyPublisher<Bool, Never> {
                isEmailValid
                    .combineLatest($accountBehavior, $password, $verifyPassword)
                    .map { validEmail, accountBehavior, password, verifyPassword -> Bool in
                        guard validEmail && !password.isEmpty else {
                            return false
                        }
                        switch accountBehavior {
                        case .login:
                            return true
                        case .register:
                            return password == verifyPassword
                        }
                    }
                    .eraseToAnyPublisher()
            }
        }
        
        var checker = AccountChecker()

        var isValid: Bool = false
        var isEmailValid: Bool = false
        
        var registerRequesting = false
        var loginRequesting = false
        
        var showingAccountBehaviorIndicator: Bool { registerRequesting || loginRequesting }

        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?

        var loginError: AppError?
    }
}
