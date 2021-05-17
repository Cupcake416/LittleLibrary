//
//  Book.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import Foundation

struct Book: Identifiable, Codable {
    
    let id: Int
    let title: String
    let press: String
    let year: Int
    let author: String
    let price: Float
    let total: Int
    let stock: Int
    
    init(id: Int, title: String, press: String, year: Int, author: String, price: Float, total: Int, stock: Int) {
        self.id = id
        self.title = title
        self.press = press
        self.year = year
        self.author = author
        self.price = price
        self.total = total
        self.stock = stock
    }
}
