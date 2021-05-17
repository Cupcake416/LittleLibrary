//
//  BookRootView.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct BookRootView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        if store.appState.bookList.books == nil {
            if store.appState.bookList.booksLoadingError != nil {
                RetryButton {
                    self.store.dispatch(.loadBooks)
                }.offset(y: -40)
            } else {
                LoadingView()
                    .offset(y: -40)
                    .onAppear {
                        self.store.dispatch(.loadBooks)
                    }
            }
        } else {
            NavigationView {
                BookList()
                    .navigationBarTitle("图书")
                    .navigationBarHidden(true)
                
            }
        }
    }
    
    struct RetryButton: View {

        let block: () -> Void

        var body: some View {
            Button(action: {
                self.block()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray)
                )
            }
        }
    }
}


struct BookRootView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.bookList.books = BookViewModel.all
        return BookRootView().environmentObject(store)
    }
}
