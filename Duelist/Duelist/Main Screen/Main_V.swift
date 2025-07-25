//
//  Main_V.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

var currentLoggedInUser: Friend = user04 //FIXME: Need to update the user info after they log in. Needs to be accessed by other views too

struct Main_V: View {
    @EnvironmentObject var nav: NavigationHandler
    
    var body: some View {
        VStack{
            Image("swords")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            D_Button(action: {
                // FIXME: implement login database logic
                NavigationHandler.animatePageChange {
                    nav.currentPage = .dualScreen
                }
            }) {
                Text("DUEL!")
            }
            
            D_Button(action: {
                // FIXME: implement login database logic
                NavigationHandler.animatePageChange {
                    nav.currentPage = .storePage
                }
            }) {
                Text("Customize")
            }
            
            D_Button(action: {
                // FIXME: implement login database logic
                NavigationHandler.animatePageChange {
                    nav.currentPage = .profile
                }
            }) {
                Text("Profile")
            }
            
            D_Button(action: {
                // FIXME: implement login database logic
                NavigationHandler.animatePageChange {
                    nav.currentPage = .friendsList
                }
            }) {
                Text("View Friends")
            }
            
            D_Button(action: {
                // FIXME: implement login database logic
                NavigationHandler.animatePageChange {
                    nav.currentPage = .leaderboard
                }
            }) {
                Text("Leaderboard")
            }
            
        }
    }
}

#Preview {
    Main_V()
}
