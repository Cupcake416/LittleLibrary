//
//  CardViewModel.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import Foundation

struct BorrowViewModel: Identifiable, Codable {
    
    let borrow: Borrow
    
    init(borrow: Borrow) {
        self.borrow = borrow
    }
    
    var id: Int {borrow.id}
    var cid: Int {borrow.cid}
    var bid: Int {borrow.bid}
    var borrowDate: String? {borrow.borrowDate}
    var returnDate: String? {borrow.returnDate}
    var adminName: String {borrow.adminName}
}
