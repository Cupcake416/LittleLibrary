//
//  Store.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/26.
//

import Foundation
import Combine
import SwiftUI

class Store: ObservableObject {
    @Published var appState = AppState()

    private var disposeBag = Set<AnyCancellable>()

    init() {
        setupObservers()
    }
    
    func setupObservers() {
        appState.userInfo.checker.isValid.sink { isValid in
            self.dispatch(.accountBehaviorButton(enabled: isValid))
        }.store(in: &disposeBag)

        appState.userInfo.checker.isEmailValid.sink { isValid in
            self.dispatch(.emailValid(valid: isValid))
        }.store(in: &disposeBag)
    }

    func dispatch(_ action: AppAction) {
        print("[ACTION]: \(action)")
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            print("[COMMAND]: \(command)")
            command.execute(in: self)
        }
    }

    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand? = nil

        switch action {
        case .accountBehaviorButton(let isValid):
            appState.userInfo.isValid = isValid
            
        case .emailValid(let isValid):
            appState.userInfo.isEmailValid = isValid
            
        case .register(let email, let password1, let password2):
            appState.userInfo.registerRequesting = true
            appCommand = RegisterAppCommand(email: email, password1: password1, password2: password2)

        case .login(let email, let password):
            appState.userInfo.loginRequesting = true
            appCommand = LoginAppCommand(email: email, password: password)

        case .logout:
            appState.userInfo.loginUser = nil

        case .accountBehaviorDone(let result):
            appState.userInfo.registerRequesting = false
            appState.userInfo.loginRequesting = false

            switch result {
            case .success(let user):
                appState.userInfo.loginUser = user
            case .failure(let error):
                appState.userInfo.loginError = error
            }

        case .toggleBookListSelection(let index):
            let expanding = appState.bookList.selectionState.expandingIndex
            if expanding == index {
                appState.bookList.selectionState.expandingIndex = nil
                appState.bookList.selectionState.panelPresented = false
                appState.bookList.selectionState.editPanelPresented = false
                appState.bookList.selectionState.radarProgress = 0
            } else {
                appState.bookList.selectionState.expandingIndex = index
                appState.bookList.selectionState.panelIndex = index
                appState.bookList.selectionState.radarShouldAnimate =
                    appState.bookList.selectionState.radarProgress == 1 ? false : true
            }

        case .setBookEditPanelBehavior(let behavior):
            appState.bookList.editPanelState.editPanelBehavior = behavior
            
        case .toggleBookPanelPresenting(let presenting):
            appState.bookList.selectionState.panelPresented = presenting
            appState.bookList.selectionState.editPanelPresented = false
            
        case .toggleBookEditPanelPresenting(let presenting):
            appState.bookList.selectionState.panelPresented = false
            appState.bookList.selectionState.editPanelPresented = presenting
            
            if presenting {
                if appState.bookList.editPanelState.editPanelBehavior == .modify {
                    let index = appState.bookList.selectionState.expandingIndex
                    let model = appState.bookList.books![index!]!
                    appState.bookList.editPanelState.titleText = model.title
                    appState.bookList.editPanelState.authorText = model.author
                    appState.bookList.editPanelState.pressText = model.press
                    appState.bookList.editPanelState.yearText = String(model.year)
                    appState.bookList.editPanelState.priceText = String(model.price)
                    appState.bookList.editPanelState.stockText = String(model.stock)
                    appState.bookList.editPanelState.totalText = String(model.total)
                } else {
                    appState.bookList.editPanelState.titleText = ""
                    appState.bookList.editPanelState.authorText = ""
                    appState.bookList.editPanelState.pressText = ""
                    appState.bookList.editPanelState.yearText = ""
                    appState.bookList.editPanelState.priceText = ""
                    appState.bookList.editPanelState.stockText = ""
                    appState.bookList.editPanelState.totalText = ""
                }
            }
            
        case .modifyBook(let book):
            if appState.userInfo.loginUser == nil {
                appState.common.showingAlert = true
                appState.common.alertMessage = "请先登陆"
                break
            }
            appState.bookList.editingBooks = true
            appState.bookList.bookEditError = nil
            appCommand = EditBookCommand(book: book)
            
        case .addNewBook(let book):
            if appState.userInfo.loginUser == nil {
                appState.common.showingAlert = true
                appState.common.alertMessage = "请先登陆"
                break
            }
            appState.bookList.editingBooks = true
            appState.bookList.bookEditError = nil
            appCommand = AddNewBookCommand(book: book)
            
        case .deleteBook(let id):
            if appState.userInfo.loginUser == nil {
                appState.common.showingAlert = true
                appState.common.alertMessage = "请先登陆"
                break
            }
            appState.bookList.editingBooks = true
            appState.bookList.bookEditError = nil
            appCommand = DeleteBookCommand(id: id)
            
        case .editBookDone(let result):
            appState.bookList.editingBooks = false
            
            switch result {
            case .success(let models):
                if appState.bookList.books != nil {
                    appState.bookList.books![models.id] = models
                } else {
                    appState.bookList.books = Dictionary(uniqueKeysWithValues: [(models.id, models)] )
                }
                
            case .failure(let error):
                appState.bookList.bookEditError = error
                
                appState.common.showingAlert = true
                appState.common.alertMessage = "编辑失败"
            }
        
        case .deleteBookDone(let result):
            appState.bookList.editingBooks = false
            
            switch result {
            case .success(let id):
                if let index = appState.bookList.books?.index(forKey: id) {
                    appState.bookList.books?.remove(at: index)
                } else {
                    appState.common.showingAlert = true
                    appState.common.alertMessage = "删除失败"
                }
                
            case .failure(let error):
                appState.bookList.bookEditError = error
                appState.common.showingAlert = true
                appState.common.alertMessage = "删除失败"
            }
        case .loadBooks:
            if appState.bookList.loadingBooks {
                break
            }
            appState.bookList.booksLoadingError = nil
            appState.bookList.loadingBooks = true
            appCommand = LoadBooksCommand()

        case .loadBooksDone(let result):
            appState.bookList.loadingBooks = false

            switch result {
            case .success(let models):
                appState.bookList.books =
                    Dictionary(uniqueKeysWithValues: models.map { ($0.id, $0) })
            case .failure(let error):
                appState.bookList.booksLoadingError = error
                appState.common.showingAlert = true
                appState.common.alertMessage = "加载失败"
            }
            
        case .loadCards:
            if appState.cardList.loadingCards {
                break
            }
            appState.cardList.cardsLoadingError = nil
            appState.cardList.loadingCards = true
            appCommand = LoadCardsCommand()
            
        case .loadCardsDone(let result):
            appState.cardList.loadingCards = false

            switch result {
            case .success(let models):
                appState.cardList.cards =
                    Dictionary(uniqueKeysWithValues: models.map { ($0.id, $0) })
            case .failure(let error):
                appState.cardList.cardsLoadingError = error
                appState.common.showingAlert = true
                appState.common.alertMessage = "加载失败"
            }
            
        case .toggleCardListSelection(let index):
            let expanding = appState.cardList.selectionState.expandingIndex
            if expanding == index {
                appState.cardList.selectionState.expandingIndex = nil
            } else {
                appState.cardList.selectionState.expandingIndex = index
                appState.cardList.selectionState.panelIndex = index
            }
        
        case .toggleCardPanelPresenting(let presenting):
            appState.cardList.selectionState.panelPresented = presenting
            appState.cardList.selectionState.editPanelPresented = false
            appState.cardList.selectionState.newPanelPresented = false
            
        case .toggleCardEditPanelPresenting(let presenting):
            appState.cardList.selectionState.panelPresented = false
            appState.cardList.selectionState.editPanelPresented = presenting
            appState.cardList.selectionState.newPanelPresented = false
            
            appState.cardList.editPanelState.editPanelBehavior = .borrow
            appState.cardList.editPanelState.bookIdText = ""
        
        case .toggleCardNewPanelPresenting(let presenting):
            appState.cardList.selectionState.panelPresented = false
            appState.cardList.selectionState.editPanelPresented = false
            appState.cardList.selectionState.newPanelPresented = presenting
            
            appState.cardList.newPanelState.nameText = ""
            appState.cardList.newPanelState.unitText = ""
            appState.cardList.newPanelState.ctype = .student
        
        case .addNewCard(let card):
            if appState.userInfo.loginUser == nil {
                appState.common.showingAlert = true
                appState.common.alertMessage = "请先登陆"
                break
            }
            appState.cardList.editingCards = true
            appState.cardList.cardEditError = nil
            appCommand = AddNewCardCommand(card: card)
            
        case .editCardDone(let result):
            appState.cardList.editingCards = false
            
            switch result {
            case .success(let models):
                if appState.cardList.cards != nil {
                    appState.cardList.cards![models.id] = models
                } else {
                    appState.cardList.cards = Dictionary(uniqueKeysWithValues: [(models.id, models)] )
                }
            case .failure(let error):
                appState.cardList.cardEditError = error
                appState.common.showingAlert = true
                appState.common.alertMessage = "编辑失败"
            }
        
        case .deleteCard(let id):
            if appState.userInfo.loginUser == nil {
                appState.common.showingAlert = true
                appState.common.alertMessage = "请先登陆"
                break
            }
            appState.cardList.editingCards = true
            appState.cardList.cardEditError = nil
            appCommand = DeleteCardCommand(id: id)
            
        case .deleteCardDone(let result):
            appState.cardList.editingCards = false
            
            switch result {
            case .success(let id):
                if let index = appState.cardList.cards?.index(forKey: id) {
                    appState.cardList.cards?.remove(at: index)
                } else {
                    appState.common.showingAlert = true
                    appState.common.alertMessage = "删除失败"
                }
            case .failure(let error):
                appState.cardList.cardEditError = error
                appState.common.showingAlert = true
                appState.common.alertMessage = "删除失败"
            }
            
        case .loadBorrows(let cid):
            if appState.cardList.loadingBorrows { break }
            appState.cardList.loadingBorrows = true
            appState.cardList.loadingBorrowsCid = cid
            appState.cardList.cardsLoadingError = nil
            appCommand = LoadBorrowsCommand(cid: cid)
        
        case .loadBorrowsDone(let result):
            appState.cardList.loadingBorrows = false
            switch result {
            case .success(let models):
                let cid = appState.cardList.loadingBorrowsCid
                if appState.cardList.cards != nil && appState.cardList.cards![cid] != nil {
                    appState.cardList.cards![cid]!.card.borrows = models
                }
            case .failure(let error):
                appState.cardList.borrowsLoadingError = error
                appState.common.showingAlert = true
                appState.common.alertMessage = "加载失败"
            }
        
        case .borrowBook(let borrow):
            if appState.userInfo.loginUser == nil {
                appState.common.showingAlert = true
                appState.common.alertMessage = "请先登陆"
                break
            }
            appState.cardList.editingBorrows = true
            appState.cardList.editBorrowsError = nil
            appCommand = BorrowBookCommand(borrow: borrow)
            
        case .borrowBookDone(let result):
            appState.cardList.editingBorrows = false
            appState.common.showingAlert = true
            switch result {
            case .success(let borrow):
                let cid = borrow.cid
                if appState.cardList.cards != nil && appState.cardList.cards![cid] != nil {
                    appState.cardList.cards![cid]!.card.borrows.append(borrow)
                }
                appState.common.alertMessage = "借书成功"
            case .failure(let error):
                appState.cardList.editBorrowsError = error
                appState.common.alertMessage = "借书失败"
            }
        
        case .returnBook(let borrow):
            if appState.userInfo.loginUser == nil {
                appState.common.showingAlert = true
                appState.common.alertMessage = "请先登陆"
                break
            }
            appState.cardList.editingBorrows = true
            appState.cardList.editBorrowsError = nil
            appCommand = ReturnBookCommand(borrow: borrow)
        
        case .returnBookDone(let result):
            appState.cardList.editingBorrows = false
            appState.common.showingAlert = true
            
            switch result {
            case .success(let result):
                appState.common.alertMessage = (result == -1) ? "还书失败" : "还书成功"
            case .failure(let error):
                appState.cardList.editBorrowsError = error
                appState.common.alertMessage = "还书失败"
            }
        
        case .showBookDeleteAlert(let id):
            appState.bookList.showingDeleteAlert = true
            appState.bookList.deleteId = id
        
        case .showCardDeleteAlert(let id):
            appState.cardList.showingDeleteAlert = true
            appState.cardList.deleteId = id
            
        }
        return (appState, appCommand)
        
        
    }
    
}

