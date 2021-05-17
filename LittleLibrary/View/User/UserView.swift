//
//  UserView.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var store: Store
    
    var userInfo: AppState.UserInfo { store.appState.userInfo }
    var userInfoBinding: Binding<AppState.UserInfo> { $store.appState.userInfo }
    
    var body: some View {
        ZStack {
            Color(UIColor(rgb: 0xEEF1F6))
                .ignoresSafeArea()
            VStack{
                HStack{
                    Text("用户")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    Spacer()
                }
                .padding(.top, 40)
                Form {
                    Section(header: Text("")) {
                        if userInfo.loginUser == nil {
                            Picker(selection: userInfoBinding.checker.accountBehavior, label: Text("")) {
                                ForEach(AppState.UserInfo.AccountBehavior.allCases, id: \.self) {
                                    Text($0.text)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            TextField("电子邮箱", text: userInfoBinding.checker.email)
                                .foregroundColor(userInfo.isEmailValid ? .green : .red)
                            SecureField("密码", text: userInfoBinding.checker.password)
                            if userInfo.checker.accountBehavior == .register {
                                SecureField("确认密码", text: userInfoBinding.checker.verifyPassword)
                            }
                            
                            Button(userInfo.checker.accountBehavior.text) {
                                let checker = self.userInfo.checker
                                switch checker.accountBehavior {
                                case .register:
                                    self.store.dispatch(.register(email: checker.email, password1: checker.password, password2: checker.verifyPassword))
                                case .login:
                                    self.store.dispatch(.login(email: checker.email, password: checker.password))
                                }
                            }
                            .disabled(!userInfo.isValid)
                        } else {
                            Text(userInfo.loginUser!.email)
                            Button("注销") {
                                self.store.dispatch(.logout)
                            }
                        }
                    }
                    
                    Section {
                        Button(action: {
                            print("清空缓存")
                        }) {
                            Text("清空缓存").foregroundColor(.red)
                        }
                    }
                    
                    Section {
                        Button(action: {
                            print("从文件导入图书")
                        }) {
                            Text("从文件导入图书").foregroundColor(.blue)
                        }
                    }
                }
                .alert(item: userInfoBinding.loginError) { error in
                    Alert(title: Text(error.localizedDescription))
                }
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView().environmentObject(Store())
    }
}

extension AppState.UserInfo.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}
