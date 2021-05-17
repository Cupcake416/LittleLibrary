//
//  CardInfoRow.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct CardInfoRow: View {
    
    @EnvironmentObject var store: Store
    
    let model: CardViewModel
    let expanded: Bool
    
    var body: some View {
        VStack(spacing: expanded ? 0 : -50){
            HStack {
                Text(model.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(height: 50)
                Spacer()
                Text("\(model.id)")
                    .font(.title3)
                    .frame(width: 50, height:50, alignment: .center)
            }
            Spacer()
            VStack(alignment: .leading){
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        Text("单位")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("类型")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    VStack(alignment: .leading, spacing: 10){
                        Text("\(model.unit)")
                            .font(.footnote)
                            .foregroundColor(.blue)
                        Text("\(model.ctype.rawValue)")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    
                }
                HStack(spacing: expanded ? 20 : -30) {
                    Spacer()
                    Button(action: {
                        self.store.dispatch(.showCardDeleteAlert(id: model.id))
                    }) {
                        Image(systemName: "trash")
                            .modifier(ToolButtonModifier())
                        
                    }
                    .frame(width: 40, height:40, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                Color.white
                            )
                            .shadow(radius: 5)
                    )
                    
                    Button(action: {
                        let target = !self.store.appState.cardList.selectionState.editPanelPresented
                        self.store.dispatch(.toggleCardEditPanelPresenting(presenting: target))
                    }) {
                        Image(systemName: "wrench")
                            .modifier(ToolButtonModifier())
                    }
                    .frame(width: 40, height:40, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                Color.white
                            )
                            .shadow(radius: 5)
                    )
                    
                    Button(action: {
                        let target = !self.store.appState.cardList.selectionState.panelPresented
                        self.store.dispatch(.toggleCardPanelPresenting(presenting: target))

                        if target {
                            self.store.dispatch(.loadBorrows(cid: model.id))
                        }
                    }) {
                        Image(systemName: "info.circle")
                            .modifier(ToolButtonModifier())
                    }
                    .frame(width: 40, height:40, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                Color.white
                            )
                            .shadow(radius: 5)
                    )
                }
                .padding(.bottom, 12)
            }
            .opacity(expanded ? 1.0 : 0.0)
            .frame(maxHeight: expanded ? .infinity : 0)
        }
        .frame(height: expanded ? 150 : 50)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, Color.white]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(radius: 5)
        )
        .padding(.horizontal)
    }
}

struct CardInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.cardList.cards = CardViewModel.all
        
        return
            ZStack{
                Color(UIColor(rgb: 0xEEF1F6))
                    .ignoresSafeArea()
                VStack{
                    CardInfoRow(model: CardViewModel.sample(id: 1), expanded: false).environmentObject(store)
                    CardInfoRow(model: CardViewModel.sample(id: 1), expanded: true).environmentObject(store)
                }
            }
            
    }
}
