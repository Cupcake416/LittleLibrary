//
//  Book.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import Foundation

struct Borrow: Identifiable, Codable {
    let id: Int
    let cid: Int
    let bid: Int
    let borrowDate: String?
    let returnDate: String?
    let adminName: String
}
