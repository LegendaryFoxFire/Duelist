//
//  LeaderboardProfile.swift
//  Duelist
//
//  Created by Sam on 22/07/25.
//
// profile shown when you tap on a leaderboard entry in list

import SwiftUI

struct LeaderboardProfile: View {
    @EnvironmentObject var nav: NavigationHandler
    
    var friend: Friend
    
    @State private var userRank: Int = 0
    @State private var isLoadingRank = true
    
    var body: some View {
        BackButton(label:"Leaderboard", destination: .leaderboard) {
            VStack{
                
                VStack{
                    D_Label(title: "Profile", fontSize: Globals.LargeTitleFontSize)
                    ProfilePhotoTemplate(size: .large, image: friend.image)
                }
                
                Grid(alignment: .leading, horizontalSpacing: Globals.StandardHSpacing, verticalSpacing: Globals.StandardVSpacing) {
                    GridRow {
                        D_Label(title: "Username: ", fontSize: Globals.SmallTitleFontSize)
                            .font(.title)
                            .bold()
                        D_Label(title: friend.friendsUserID, fontSize: Globals.SmallTitleFontSize)
                            .font(.title)
                    }
                    GridRow {
                        D_Label(title: "Total Wins: ", fontSize: Globals.SmallTitleFontSize)
                            .font(.title)
                            .bold()
                        D_Label(title: String(friend.numberOfWins), fontSize: Globals.SmallTitleFontSize)
                            .font(.title)
                    }
                    GridRow {
                        D_Label(title: "Rank: ", fontSize: Globals.SmallTitleFontSize)
                            .font(.title)
                            .bold()
                        
                        if isLoadingRank {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            D_Label(title: String(userRank), fontSize: Globals.SmallTitleFontSize)
                                .font(.title)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: Globals.CornerRadius)
                        .stroke(Color.black, lineWidth: 2)
                        .background(Color.black.opacity(0.15))
                )
                .padding(.horizontal)
                Spacer()
            }
        }
        .onAppear {
            calculateUserRank()
        }
    }
    
    private func calculateUserRank() {
        Task {
            do {
                await MainActor.run {
                    isLoadingRank = true
                }
                
                let rank = try await FirebaseService.shared.getUserRank(for: friend.id.uuidString)
                
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
