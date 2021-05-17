//
//  BookViewModel.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import Foundation
 
struct BookViewModel: Identifiable, Codable {
    let book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    var id: Int {book.id}
    var title: String {book.title}
    var press: String {book.press}
    var author: String {book.author}
    var price: Float {book.price}
    var total: Int {book.total}
    var stock: Int {book.stock}
    var year: Int {book.year}
}
