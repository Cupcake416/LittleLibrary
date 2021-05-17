//
//  CardRootView.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct CardRootView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        if store.appState.cardList.cards == nil {
            if store.appState.cardList.cardsLoadingError != nil {
                RetryButton {
                    self.store.dispatch(.loadCards)
                }.offset(y: -40)
            } else {
                LoadingView()
                    .offset(y: -40)
                    .onAppear {
                        self.store.dispatch(.loadCards)
                    }
            }
        } else {
            NavigationView {
                CardList()
                    .navigationBarTitle("借书证")
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

struct CardRootView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.cardList.cards = CardViewModel.all
        return CardRootView().environmentObject(store)
    }
}
