//
//  Title_V.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

struct Title_Screen: View {
    @EnvironmentObject var nav: NavigationHandler
    
    @State private var navigateToLogin = false
    @State private var slamOffset: CGFloat = -300
    @State private var slamScale: CGFloat = 1.3

    var body: some View {
        NavigationStack {
            D_Background {
                VStack {
                    Image("transparentbgswords")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(y: slamOffset)
                        .scaleEffect(slamScale)
                        .onAppear {
                            withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                                slamOffset = 0
                                slamScale = 1.0
                            }
                        }
                    
                    D_Label(title: "Duelist", fontSize: Globals.LargeTitleFontSize)
                        .font(.system(size: 80))
                        .bold(true)
                    D_Label(title: "Tap Screen to Continue",fontSize: Globals.SmallHeadingFontSize)
                        .font(.caption)
                }
                .onTapGesture {
                    navigateToLogin = true
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .login(email: "", password: "")
                    }
                }
            }
        }
    }
}

#Preview {
    Title_Screen()
}
