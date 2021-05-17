//
//  CardViewModel.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import Foundation

struct CardViewModel: Identifiable, Codable {
    
    var card: Card
    
    init(card: Card) {
        self.card = card
    }
    
    var id: Int {card.id}
    var name: String {card.name}
    var unit: String {card.unit}
    var ctype: Card.CardType {card.ctype}
    var borrows: [BorrowViewModel] {
            card.borrows.map {
                BorrowViewModel(borrow: $0)
            }
        }
}
