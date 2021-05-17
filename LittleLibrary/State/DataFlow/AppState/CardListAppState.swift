//
//  CardListAppState.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/28.
//

import Foundation

extension AppState {
    struct  CardList {
        
        enum EditPanelBehavior: CaseIterable {
            case borrow, retn
        }
        
        enum NewCardType: CaseIterable {
            case teacher, student
        }
        
        struct SelectionState {
            var expandingIndex: Int? = nil
            var panelIndex: Int? = nil
            var panelPresented = false
            var editPanelPresented = false
            var newPanelPresented = false
            
            func isExpanding(_ id: Int) -> Bool {
                expandingIndex == id
            }
        }
        struct EditPanelState {
            var editPanelBehavior = EditPanelBehavior.borrow
            var bookIdText: String = ""
        }
        
        struct NewPanelState {
            var nameText: String = ""
            var unitText: String = ""
            var ctype: Card.CardType = .student
        }
        
        var loadingCards = false
        var editingCards = false
        var editingBorrows = false
        var loadingBorrows = false
        var loadingBorrowsCid = 0
        var cardsLoadingError: AppError?
        var borrowsLoadingError: AppError?
        var editBorrowsError: AppError?
        
        var selectionState = SelectionState()
        var editPanelState = EditPanelState()
        var newPanelState = NewPanelState()
        var cardEditError: AppError?
        
        var searchText = ""
        var showingDeleteAlert = false
        var deleteId = 0
        
        var cards:[Int: CardViewModel]?
        
        func displayCards() -> [CardViewModel] {
            func containsSearchText(_ card: CardViewModel) -> Bool {
                guard !searchText.isEmpty else {
                    return true
                }
                return card.name.contains(searchText) || card.unit.contains(searchText)
            }
            
            guard let cards = cards else {
                return []
            }
            
            var filterFuncs: [(CardViewModel) -> Bool] = []
            filterFuncs.append(containsSearchText)
            
            let filterFunc = filterFuncs.reduce({ _ in true}) { r, next in
                return { card in
                    r(card) && next(card)
                }
            }
            
            return cards.values
                .filter(filterFunc)
                .sorted {
                    $0.id < $1.id
                }
        }
    }
}
