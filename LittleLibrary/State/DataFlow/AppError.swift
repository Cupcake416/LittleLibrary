//
//  AppError.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/26.
//

import Foundation


enum AppError: Error, Identifiable {
    var id: String { localizedDescription }

    case alreadyRegistered
    case emailOrPasswordWrong

    case requiresLogin
    case networkingFailed(Error)
    case fileError
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .alreadyRegistered: return "该账号已注册"
        case .emailOrPasswordWrong: return "邮箱或密码错误"
        case .requiresLogin: return "需要账户"
        case .networkingFailed(let error): return error.localizedDescription
        case .fileError: return "文件操作错误"
        }
    }
}
