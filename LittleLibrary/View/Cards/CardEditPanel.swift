//
//  BookPanel.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct CardEditPanel: View {
    
    @EnvironmentObject var store: Store
    
    var editPanelState: AppState.CardList.EditPanelState {store.appState.cardList.editPanelState}
    var editPanelStateBinding: Binding<AppState.CardList.EditPanelState> { $store.appState.cardList.editPanelState }
    
    var selectionState: AppState.CardList.SelectionState {store.appState.cardList.selectionState}
    
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
                    Picker(selection: editPanelStateBinding.editPanelBehavior, label: Text("")) {
                        ForEach(AppState.CardList.EditPanelBehavior.allCases, id: \.self) {
                            Text($0.text)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("书号", text: editPanelStateBinding.bookIdText)
                    
                    Button("确认") {
                        switch editPanelState.editPanelBehavior {
                        case .borrow:
                            let borrow = Borrow(id: 0, cid: selectionState.panelIndex ?? 0, bid: Int(editPanelState.bookIdText) ?? 0, borrowDate: "", returnDate: "", adminName: store.appState.userInfo.loginUser?.email ?? "")
                            self.store.dispatch(.borrowBook(borrow: borrow))
                        case .retn:
                            let borrow = Borrow(id: 0, cid: selectionState.panelIndex ?? 0, bid: Int(editPanelState.bookIdText) ?? 0, borrowDate: "", returnDate: "已归还", adminName: store.appState.userInfo.loginUser?.email ?? "")
                            self.store.dispatch(.returnBook(borrow: borrow))
                        }
                    }
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
        .alert(isPresented: $store.appState.common.showingAlert) {
            Alert(title: Text(store.appState.common.alertMessage))
        }
    }
}

struct CardEditPanel_Previews: PreviewProvider {
    static var previews: some View {
        BookEditPanel().environmentObject(Store())
    }
}

extension AppState.CardList.EditPanelBehavior {
    var text: String {
        switch self {
        case .borrow:
            return "借书"
        case .retn:
            return "还书"
        }
    }
}
