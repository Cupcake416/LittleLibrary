//
//  BorrowInfoRow.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/29.
//

import SwiftUI

struct BorrowInfoRow: View {
    let model: BorrowViewModel
    var body: some View {
        HStack{
            Group{
                Text("\(model.bid)")
                Text("\(model.borrowDate ?? "")")
                Text("\(model.returnDate ?? "未归还")")
                Text("\(model.adminName)")
            }
            .frame(width:80, alignment: .center)
            .foregroundColor(model.returnDate == nil ? Color.blue : Color.gray)
        }
        .padding(.top, 10)
    }
}

struct BorrowInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color(UIColor(rgb: 0xEEF1F6))
                .ignoresSafeArea()
            BorrowInfoRow(model: BorrowViewModel.all(id: 1).first!)
        }
        
    }
}
