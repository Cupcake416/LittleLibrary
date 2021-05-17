//
//  BookList.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct BookList: View {
    
    @EnvironmentObject var store: Store
    
//    var bookList: AppState.BookList {store.appState.bookList}
    
    var body: some View {
        ZStack{
            Color(UIColor(rgb: 0xEEF1F6))
                .ignoresSafeArea()
            VStack{
                HStack{
                    Text("图书")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    Spacer()
                    Button(action: {
                        self.store.dispatch(.setBookEditPanelBehavior(behavior: .addnew))
                        let target = !self.store.appState.bookList.selectionState.editPanelPresented
                        self.store.dispatch(.toggleBookEditPanelPresenting(presenting: target))
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                    }
                    .padding(.trailing)
                }
                .padding(.top, 40)
                
                TextField("搜索", text: $store.appState.bookList.searchText.animation(nil))
                    .frame(height: 40)
                    .padding(.horizontal, 25)
                
                ScrollView {
                    ForEach(store.appState.bookList.displayBooks()) { bvm in
                        BookInfoRow(
                            model: bvm,
                            expanded: store.appState.bookList.selectionState.isExpanding(bvm.id)
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.725, blendDuration: 0)) {
                                self.store.dispatch(.toggleBookListSelection(index: bvm.id))
                            }
                        }
                        Spacer()
                            .frame(height: 8)
                    }
                }

            }
            
        }
        .alert(isPresented: $store.appState.bookList.showingDeleteAlert) {
            Alert(title: Text("确定删除图书吗？"), message: Text("相关的借书记录也会被删除") ,primaryButton: .default(Text("确认"), action: {
                self.store.dispatch(.deleteBook(id: store.appState.bookList.deleteId))
            }), secondaryButton: .cancel())
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.bookList.books = BookViewModel.all
        return BookList().environmentObject(store)
    }
}
