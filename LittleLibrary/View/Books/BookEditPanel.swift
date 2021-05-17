//
//  BookPanel.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct BookEditPanel: View {
    
    @EnvironmentObject var store: Store
    
    var editPanelState: AppState.BookList.EditPanelState {store.appState.bookList.editPanelState}
    var editPanelStateBinding: Binding<AppState.BookList.EditPanelState> { $store.appState.bookList.editPanelState }

    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    var body: some View {
        VStack{
            topIndicator
            Form {
                Section {
                    TextField("标题", text: editPanelStateBinding.titleText)
                    TextField("作者", text: editPanelStateBinding.authorText)
                    TextField("出版社", text: editPanelStateBinding.pressText)
                    TextField("年份", text: editPanelStateBinding.yearText)
                }
                
                Section {
                    TextField("价格", text: editPanelStateBinding.priceText)
                }
                
                Section {
                    TextField("库存", text: editPanelStateBinding.stockText)
                    TextField("总藏书量", text: editPanelStateBinding.totalText)
                }
                
                Button("确认") {
                    let selectionState = store.appState.bookList.selectionState
                    
                    let book = Book(id: selectionState.expandingIndex ?? 0, title: editPanelState.titleText, press: editPanelState.pressText, year: Int(editPanelState.yearText) ?? 0, author: editPanelState.authorText, price: Float(editPanelState.priceText) ?? 0, total: Int(editPanelState.totalText) ?? 0, stock: Int(editPanelState.stockText) ?? 0)
                    
                    switch editPanelState.editPanelBehavior {
                    case .modify:
                        self.store.dispatch(.modifyBook(book: book))
                    default:
                        self.store.dispatch(.addNewBook(book: book))
                    }
                    
                    self.store.dispatch(.toggleBookEditPanelPresenting(presenting: false))
                }
            }
            .adaptsToKeyboard()
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor(Color.blue.opacity(0.0))
            }
            
        }
        .padding(
            EdgeInsets(
                top: 12,
                leading: 30,
                bottom: 30,
                trailing: 30
            )
        )
        .blurBackground(style: .systemMaterial)
        .cornerRadius(20)
        .frame(height: 600)
    }
}

struct BookEditPanel_Previews: PreviewProvider {
    static var previews: some View {
//        let store = Store()
        BookEditPanel().environmentObject(Store())
    }
}
