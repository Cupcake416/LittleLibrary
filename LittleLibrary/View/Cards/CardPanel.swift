//
//  CardPanel.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct CardPanel: View {
    let model: CardViewModel
    
    var sectionBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray)
        
    }
    
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    var body: some View {
        VStack(alignment: .center){
            topIndicator
            Text("借书记录")
                .font(.title3)
                .padding(.vertical)
            HStack{
                Text("书号")
                    .foregroundColor(.white)
                    .frame(width:80, alignment: .center)
                    .background(
                        sectionBackground
                    )
                Text("借出日期")
                    .foregroundColor(.white)
                    .frame(width:80, alignment: .center)
                    .background(
                        sectionBackground
                    )
                Text("归还日期")
                    .foregroundColor(.white)
                    .frame(width:80, alignment: .center)
                    .background(
                        sectionBackground
                    )
                Text("经手人")
                    .foregroundColor(.white)
                    .frame(width:80, alignment: .center)
                    .background(
                        sectionBackground
                    )
            }
            
            ScrollView{
                ForEach(model.borrows) {borrow in
                    BorrowInfoRow(
                        model: borrow
                    )
                }
            }   
            Spacer()
        }
        .padding(
            EdgeInsets(
                top: 12,
                leading: 30,
                bottom: 30,
                trailing: 30
            )
        )
        .frame(minHeight: 400)
        .blurBackground(style: .systemMaterial)
        .cornerRadius(20)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct CardPanel_Previews: PreviewProvider {
    static var previews: some View {
        CardPanel(model: CardViewModel.sample(id: 1))
    }
}
