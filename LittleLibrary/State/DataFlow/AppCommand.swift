//
//  AppCommand.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/26.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: Store)
}


struct LoadBooksCommand: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoadAllBookRequest.all
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.loadBooksDone(result: .failure(error)))
                    }
                    token.unseal()
                }, receiveValue: { value in
                    store.dispatch(.loadBooksDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}

struct LoadCardsCommand: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoadAllCardRequest.all
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.loadCardsDone(result: .failure(error)))
                    }
                    token.unseal()
                }, receiveValue: { value in
                    store.dispatch(.loadCardsDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}

struct EditBookCommand: AppCommand {
    let book: Book
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        EditBookRequest(book: book)
        .publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.editBookDone(result: .failure(error)))
                }
                token.unseal()
            },
            receiveValue: { value in
                store.dispatch(.editBookDone(result: .success(value)))
            }
        ).seal(in: token)
    }
}

struct AddNewBookCommand: AppCommand {
    let book: Book
    
    func  execute(in store: Store) {
        let token = SubscriptionToken()
        AddNewBookRequest(book: book)
        .publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.editBookDone(result: .failure(error)))
                }
                token.unseal()
            },
            receiveValue: { value in
                store.dispatch(.editBookDone(result: .success(value)))
            }
        ).seal(in: token)
    }
}

struct DeleteBookCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        DeleteBookRequest(id: id)
        .publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.deleteBookDone(result: .failure(error)))
                }
                token.unseal()
            },
            receiveValue: { value in
                store.dispatch(.deleteBookDone(result: .success(value)))
            }
        ).seal(in: token)
    }
}

struct AddNewCardCommand: AppCommand {
    let card: Card
    
    func  execute(in store: Store) {
        let token = SubscriptionToken()
        AddNewCardRequest(card: card)
        .publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.editCardDone(result: .failure(error)))
                }
                token.unseal()
            },
            receiveValue: { value in
                store.dispatch(.editCardDone(result: .success(value)))
            }
        ).seal(in: token)
    }
}

struct DeleteCardCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        DeleteCardRequest(id: id)
        .publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.deleteCardDone(result: .failure(error)))
                }
                token.unseal()
            },
            receiveValue: { value in
                store.dispatch(.deleteCardDone(result: .success(value)))
            }
        ).seal(in: token)
    }
}

struct LoadBorrowsCommand: AppCommand {
    let cid: Int
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoadBorrowsRequest(cid: cid).publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.loadBorrowsDone(result: .failure(error)))
                    }
                    token.unseal()
                }, receiveValue: { value in
                    store.dispatch(.loadBorrowsDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}

struct BorrowBookCommand: AppCommand {
    let borrow: Borrow
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        BorrowBookRequest(borrow: borrow).publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.borrowBookDone(result: .failure(error)))
                    }
                    token.unseal()
                }, receiveValue: { value in
                    store.dispatch(.borrowBookDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}

struct ReturnBookCommand: AppCommand {
    let borrow: Borrow
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        ReturnBookRequest(borrow: borrow).publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.returnBookDone(result: .failure(error)))
                    }
                    token.unseal()
                }, receiveValue: { value in
                    store.dispatch(.returnBookDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}

struct RegisterAppCommand: AppCommand {
    let email: String
    let password1: String
    let password2: String

    func execute(in store: Store) {
        let token = SubscriptionToken()
        RegisterRequest(
            email: email,
            password1: password1,
            password2: password2
        ).publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.accountBehaviorDone(result: .failure(error)))
                }
                token.unseal()
            },
            receiveValue: { user in
                if user.email == "@fail" {
                    store.dispatch(.accountBehaviorDone(result: .failure(AppError.alreadyRegistered)))
                } else {
                    store.dispatch(.accountBehaviorDone(result: .success(user)))
                }
            }
        ).seal(in: token)
    }
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String

    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoginRequest(
            email: email,
            password: password
        ).publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.accountBehaviorDone(result: .failure(error)))
                }
                token.unseal()
            },
            receiveValue: { user in
                if user.email == "@fail" {
                    let error = AppError.emailOrPasswordWrong
                    store.dispatch(.accountBehaviorDone(result: .failure(error)))
                } else {
                    store.dispatch(.accountBehaviorDone(result: .success(user)))
                }
                
            }
        )
        .seal(in: token)
    }
}

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
