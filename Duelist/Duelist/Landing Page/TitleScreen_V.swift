//
//  TitleScreen_V.swift
//  Duelist
//
//  Created by John Bukoski on 7/19/25.
//

import SwiftUI

struct TitleScreen: View{
    @EnvironmentObject var nav: NavigationHandler
    
    var body: some View {
        VStack {
            Text("Title Screen")
                .font(.largeTitle)
                .padding()
            
            Button("Go to Login") {
                NavigationHandler.animatePageChange {
                    nav.currentPage = .login(email: "", password: "")
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    TitleScreen()
}
