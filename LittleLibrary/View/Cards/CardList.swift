//
//  CardList.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct CardList: View {
    
    @EnvironmentObject var store: Store
    
//    var cardList: AppState.CardList {store.appState.cardList}
    
    var body: some View {
        ZStack{
            Color(UIColor(rgb: 0xEEF1F6))
                .ignoresSafeArea()
            VStack {
                HStack{
                    Text("借书证")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    Spacer()
                    Button(action: {
                        let target = !self.store.appState.cardList.selectionState.newPanelPresented
                        self.store.dispatch(.toggleCardNewPanelPresenting(presenting: target))
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                    }
                    .padding(.trailing)
                }
                .padding(.top, 40)
                
                ScrollView {
                    TextField("搜索", text: $store.appState.cardList.searchText.animation(nil))
                        .frame(height: 40)
                        .padding(.horizontal, 25)
                    ForEach(store.appState.cardList.displayCards()) { cvm in
                        CardInfoRow(
                            model: cvm,
                            expanded: store.appState.cardList.selectionState.expandingIndex == cvm.id
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.725, blendDuration: 0)) {
                                self.store.dispatch(.toggleCardListSelection(index: cvm.id))
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $store.appState.cardList.showingDeleteAlert) {
            Alert(title: Text("确定删除借书证吗？"), primaryButton: .default(Text("确认"), action: {
                self.store.dispatch(.deleteCard(id: store.appState.cardList.deleteId))
            }), secondaryButton: .cancel())
        }
    }
}

struct CardList_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.cardList.cards = CardViewModel.all
        
        return CardList().environmentObject(store)
    }
}
