//
//  APPSTATE.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/26.
//

import Foundation
import Combine

struct AppState {
    var bookList = BookList()
    var cardList = CardList()
    var userInfo = UserInfo()
    var mainTab = MainTab()
    var common = Common()
}

extension AppState {
    struct Common {
        var showingAlert = false
        var alertMessage = ""
    }
}

extension AppState {
    struct MainTab {
        enum Index: Hashable {
            case book, card, user
        }
        
        var selection: Index = .book
    }
}
