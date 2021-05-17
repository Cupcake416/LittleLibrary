//
//  BookListAppState.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/28.
//

import Foundation

extension AppState {
    struct BookList {
        enum EditPanelBehavior: CaseIterable {
            case modify, addnew, delete
        }
        
        struct SelectionState {
            var expandingIndex: Int? = nil
            var panelIndex: Int? = nil
            var panelPresented = false
            var editPanelPresented = false
            var radarProgress: Double = 0
            var radarShouldAnimate = true
            
            func isExpanding(_ id: Int) -> Bool {
                expandingIndex == id
            }
        }
        
        struct EditPanelState {
            var titleText: String = ""
            var authorText: String = ""
            var pressText: String = ""
            var yearText: String = ""
            var priceText: String = ""
            var stockText: String = ""
            var totalText: String = ""
            var editPanelBehavior = EditPanelBehavior.addnew
        }
        
        var loadingBooks = false
        var editingBooks = false
        var booksLoadingError: AppError?

        var selectionState = SelectionState()
        var editPanelState = EditPanelState()
        var bookEditError: AppError?

        var searchText = ""
        var showingDeleteAlert = false
        var deleteId = 0
        
//        @FileStorage(directory: .cachesDirectory, fileName: "books.json")
        var books: [Int: BookViewModel]?
        
        func displayBooks() -> [BookViewModel] {
            func containsSearchText(_ book: BookViewModel) -> Bool {
                guard !searchText.isEmpty else {
                    return true
                }
                return book.title.contains(searchText) || book.author.contains(searchText) || book.press.contains(searchText)
            }
            
            guard let books = books else {
                return []
            }
            
            var filterFuncs: [(BookViewModel) -> Bool] = []
            filterFuncs.append(containsSearchText)
            
            let filterFunc = filterFuncs.reduce({ _ in true}) { r, next in
                return { book in
                    r(book) && next(book)
                }
            }
            
            return books.values
                .filter(filterFunc)
                .sorted {
                    $0.id < $1.id
                }
        }
    }
}
