//
//  UserRootView.swift
//  LittleLibrary
//
//  Created by 高伟渊 on 2021/4/25.
//

import SwiftUI

struct UserRootView: View {
    var body: some View {
        NavigationView {
            UserView()
                .navigationBarTitle("账户")
                .navigationBarHidden(true)
        }
    }
}

struct UserRootView_Previews: PreviewProvider {
    static var previews: some View {
        UserRootView().environmentObject(Store())
    }
}
