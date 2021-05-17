//
//  Card.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import Foundation

struct Card: Identifiable, Codable {
    enum CardType: String, Codable, CaseIterable{
        case teacher = "teacher"
        case student = "student"
    }
    
    let id: Int
    let name: String
    let unit: String
    let ctype: CardType
    var borrows: [Borrow] = []
}
