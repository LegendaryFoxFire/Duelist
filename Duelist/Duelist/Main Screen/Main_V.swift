//
//  Main_V.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

struct Main_V: View {
    @EnvironmentObject var nav: NavigationHandler
    
    var body: some View {
        D_Background {
            VStack{
                D_Label(title: "Main Menu", fontSize: Globals.LargeTitleFontSize)
                Image("transparentbgswords")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                D_Button(action: {
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .dualScreen
                    }
                }) {
                    Text("DUEL!")
                }
                
                D_Button(action: {
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .storePage
                    }
                }) {
                    Text("Customize")
                }
                
                D_Button(action: {
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .profile
                    }
                }) {
                    Text("Profile")
                }
                
                D_Button(action: {
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .friendsList
                    }
                }) {
                    Text("View Friends")
                }
                
                D_Button(action: {
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .leaderboard
                    }
                }) {
                    Text("Leaderboard")
                }
                
            }
        }
    }
}

#Preview {
    Main_V()
}
