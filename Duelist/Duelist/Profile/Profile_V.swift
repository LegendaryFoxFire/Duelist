//
//  Profile_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct Profile_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var globalUsersManager: GlobalUsersManager
    
    @State private var userRank: Int = 0
    @State private var isLoadingRank = true
    
    var body: some View {
        D_Background {
            BackButton(label: "Main Menu", destination: .mainMenu) {
                profileContent
            }
        }
        .onAppear {
            calculateUserRank()
        }
    }
    
    @ViewBuilder
    private var profileContent: some View {
        if let currentUser = authManager.user {
            VStack(spacing: Globals.ProfileVSpacing) {
                VStack {
                    D_Label(title: "Profile", fontSize: Globals.LargeTitleFontSize)
                    ProfilePhotoHelper.getProfileImageView(for: currentUser, size: .large)
                }
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Username: ")
                            .font(.title)
                            .bold()
                        Text(currentUser.username)
                            .font(.title)
                        Spacer()
                    }
                    
                    HStack {
                        Text("Total Wins: ")
                            .font(.title)
                            .bold()
                        Text(String(currentUser.numberOfWins))
                            .font(.title)
                        Spacer()
                    }
                    
                    HStack {
                        Text("Rank: ")
                            .font(.title)
                            .bold()
                        
                        if isLoadingRank {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Text(String(userRank))
                                .font(.title)
                        }
                        Spacer()
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: Globals.CornerRadius)
                        .stroke(Color.black, lineWidth: 2)
                )
                .padding(.horizontal)
                
                Spacer()
                
                Button("Settings") {
                    nav.currentPage = .settings
                }
                
                Spacer()
            }
            .padding(.top, Globals.ProfileVSpacing)
        } else {
            VStack {
                ProgressView("Loading Profile...")
                    .font(.title2)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // Keep your existing calculateUserRank function
    private func calculateUserRank() {
        guard let currentUser = authManager.user else { return }
        
        Task {
            do {
                await MainActor.run {
                    isLoadingRank = true
                }
                
                let rank = try await FirebaseService.shared.getUserRank(for: currentUser.userID)
                
                await MainActor.run {
                    userRank = rank
                    isLoadingRank = false
                }
            } catch {
                print("Error getting rank: \(error)")
                await MainActor.run {
                    userRank = 0
                    isLoadingRank = false
                }
            }
        }
    }
}
