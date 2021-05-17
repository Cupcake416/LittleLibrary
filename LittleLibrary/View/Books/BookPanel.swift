//
//  BookPanel.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct BookPanel: View {
    let model: BookViewModel
    
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    var body: some View {
        VStack(spacing: 20){
            topIndicator
            VStack{
                Text("\(model.title)")
                    .font(.largeTitle)
                    .padding(.bottom)
                HStack{
                    VStack(alignment: .leading, spacing: 10){
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
                        Text("总藏书量")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    VStack(alignment: .leading, spacing: 10){
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
                Spacer()
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
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct BookPanel_Previews: PreviewProvider {
    static var previews: some View {
        BookPanel(model: .sample(id: 1))
    }
}
