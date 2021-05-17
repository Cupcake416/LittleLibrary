//
//  BookInfoRow.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct BookInfoRow: View {

    @EnvironmentObject var store: Store
    
    let model: BookViewModel
    let expanded: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: expanded ? 0 : -60){
            HStack{
                Text(model.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(height: 50)
                Spacer()
                Text("\(model.id)")
                    .font(.title3)
                    .frame(width: 50, height:50, alignment: .center)
            }
            .padding(.leading)
            HStack{
                VStack(alignment: .leading, spacing: 1){
                    Text("作者")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("出版社")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("年份")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("价格")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("库存")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("总量")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 1){
                    Text("\(model.author)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    Text("\(model.press)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    Text("\(model.year)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    Text("\(model.price)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    Text("\(model.stock)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    Text("\(model.total)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .opacity(expanded ? 1.0 : 0.0)
            .padding(.leading)
            Spacer()
            HStack(spacing: expanded ? 10 : -50) {
                Spacer()
                
                Button(action: {
                    self.store.dispatch(.showBookDeleteAlert(id: model.id))
                }) {
                    Image(systemName: "trash")
                        .modifier(ToolButtonModifier())
                }
                .frame(width: 40, height: 40, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            Color.white
                        )
                        .shadow(radius: 5)
                )
                
                Button(action: {
                    self.store.dispatch(.setBookEditPanelBehavior(behavior: .modify))
                    let target = !self.store.appState.bookList.selectionState.editPanelPresented
                    self.store.dispatch(.toggleBookEditPanelPresenting(presenting: target))
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
            }
            .padding([.bottom, .trailing])
            .opacity(expanded ? 1.0 : 0.0)
        }
        .frame(minHeight: 50)
        .frame(maxHeight: expanded ? 220 : 50)
        .clipped()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    Color.white
                )
                .shadow(radius: 5)
        )
        .padding(.horizontal)
        .padding(.top, 12)
    }
    
}

struct ToolButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20))
            .foregroundColor(.black)
            .frame(width: 25, height: 25)
            .shadow(radius: 5)
    }
}

struct BookInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color(UIColor(rgb: 0xEEF1F6))
                .ignoresSafeArea()
            VStack{
                BookInfoRow(model: .sample(id: 1), expanded: false)
                BookInfoRow(model: .sample(id: 2), expanded: true)
            }
        }
        
        
    }
}
