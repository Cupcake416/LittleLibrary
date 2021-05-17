//
//  AppAction.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/26.
//

import Foundation
import Combine

enum AppAction {
    
    case loadBooks
    case loadBooksDone( result: Result<[BookViewModel], AppError> )
    case toggleBookListSelection(index: Int)
    case toggleBookPanelPresenting(presenting: Bool)
    case toggleBookEditPanelPresenting(presenting: Bool)
    case modifyBook(book: Book)
    case addNewBook(book: Book)
    case deleteBook(id: Int)
    case editBookDone(result: Result<BookViewModel, AppError>)
    case deleteBookDone(result: Result<Int, AppError>)
    case setBookEditPanelBehavior(behavior: AppState.BookList.EditPanelBehavior)
    
    case loadCards
    case loadCardsDone( result: Result<[CardViewModel], AppError> )
    case toggleCardListSelection(index: Int)
    case toggleCardPanelPresenting(presenting: Bool)
    case toggleCardEditPanelPresenting(presenting: Bool)
    case toggleCardNewPanelPresenting(presenting: Bool)
    case addNewCard(card: Card)
    case editCardDone(result: Result<CardViewModel, AppError>)
    case deleteCard(id: Int)
    case deleteCardDone(result: Result<Int, AppError>)
    
    case loadBorrows(cid: Int)
    case loadBorrowsDone( result: Result<[Borrow], AppError> )
    case borrowBook(borrow: Borrow)
    case borrowBookDone(result: Result<Borrow, AppError>)
    case returnBook(borrow: Borrow)
    case returnBookDone(result: Result<Int, AppError>)
    
    case emailValid(valid: Bool)
    case accountBehaviorButton(enabled: Bool)
    case register(email: String, password1: String, password2: String)
    case login(email: String, password: String)
    case logout
    case accountBehaviorDone(result: Result<User, AppError>)
    
    case showBookDeleteAlert(id: Int)
    case showCardDeleteAlert(id: Int)
}
