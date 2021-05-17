//
//  MainTab.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct MainTab: View {
    
    @EnvironmentObject var store: Store
    
    private var bookList: AppState.BookList {
        store.appState.bookList
    }
    
    private var bookListBinding: Binding<AppState.BookList> {
        $store.appState.bookList
    }
    
    private var selectedBookPanelIndex: Int? {
        bookList.selectionState.panelIndex
    }
    
    private var cardList: AppState.CardList {
        store.appState.cardList
    }
    
    private var cardListBinding: Binding<AppState.CardList> {
        $store.appState.cardList
    }
    
    private var selectedCardPanelIndex: Int? {
        cardList.selectionState.panelIndex
    }
    
    
    var body: some View {
        TabView(selection: $store.appState.mainTab.selection){
            BookRootView().tabItem {
                Image(systemName: "book")
                Text("图书")
            }.tag(AppState.MainTab.Index.book)
            
            CardRootView().tabItem {
                Image(systemName: "creditcard")
                Text("借书证")
            }.tag(AppState.MainTab.Index.card)
            
            UserRootView().tabItem {
                Image(systemName: "gear")
                Text("账户")
            }.tag(AppState.MainTab.Index.user)
        }
        .edgesIgnoringSafeArea(.top)
        .overlaySheet(isPresented: bookListBinding.selectionState.panelPresented) {
            if self.selectedBookPanelIndex != nil && self.bookList.books != nil {
                if let model = self.bookList.books![self.selectedBookPanelIndex!] {
                    BookPanel(model: model)
                }
            }
        }
        .overlaySheet(isPresented: bookListBinding.selectionState.editPanelPresented) {
            BookEditPanel()
        }
        .overlaySheet(isPresented: cardListBinding.selectionState.panelPresented) {
            if self.selectedCardPanelIndex != nil && self.cardList.cards != nil {
                if let model = self.cardList.cards![self.selectedCardPanelIndex!] {
                    CardPanel(model: model)
                }
            }
        }
        .overlaySheet(isPresented: cardListBinding.selectionState.editPanelPresented) {
            CardEditPanel()
        }
        .overlaySheet(isPresented: cardListBinding.selectionState.newPanelPresented) {
            CardNewPanel()
        }
        .alert(isPresented: $store.appState.common.showingAlert) {
            Alert(title: Text(store.appState.common.alertMessage))
        }
        
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
