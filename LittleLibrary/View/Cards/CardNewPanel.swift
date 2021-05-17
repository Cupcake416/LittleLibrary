//
//  BookPanel.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct CardNewPanel: View {
    
    @EnvironmentObject var store: Store
    
    var newPanelState: AppState.CardList.NewPanelState {store.appState.cardList.newPanelState}
    var newPanelStateBinding: Binding<AppState.CardList.NewPanelState> { $store.appState.cardList.newPanelState }

    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    var types = ["学生", "老师"]
    var body: some View {
        VStack{
            topIndicator
            Form {
                Section {
                    Picker(selection: newPanelStateBinding.ctype, label: Text("")){
                        ForEach(Card.CardType.allCases, id:\.self) {
                            Text($0.text)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    TextField("姓名", text: newPanelStateBinding.nameText)
                    TextField("单位", text: newPanelStateBinding.unitText)
                    Button("确认") {
                        let card = Card(id: 0, name: newPanelState.nameText, unit: newPanelState.unitText, ctype: newPanelState.ctype)
                        self.store.dispatch(.addNewCard(card: card))
                        self.store.dispatch(.toggleCardNewPanelPresenting(presenting: false))
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
    }
}

struct CardnewPanel_Previews: PreviewProvider {
    static var previews: some View {
        CardNewPanel()
    }
}

extension Card.CardType {
    var text: String {
        switch self {
        case .teacher: return "老师"
        case .student: return "学生"
        }
    }
}


