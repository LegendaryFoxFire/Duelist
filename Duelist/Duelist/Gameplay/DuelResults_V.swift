//
//  DuelResults_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct DuelResults_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @StateObject var viewModel: DuelResults_VM
    
    @State private var navigatetoSummary: Bool = false
    
    var body: some View {
        D_Background {
            ZStack {
                // Loser profile faded in background
                if let loser = viewModel.loserUser {
                    VStack(spacing: 20) {
                        ProfilePhotoHelper.getProfileImageView(for: loser, size: .large)
                            .scaleEffect(1.5)
                        
                        Text(viewModel.currentUserWon ? "Opponent" : "You")
                            .font(.title)
                            .bold()
                    }
                    .opacity(0.3)
                    .blur(radius: 2)
                    .scaleEffect(0.8)
                    .offset(x: viewModel.currentUserWon ? 50 : -50, y: 30)
                }
                
                // Winner profile prominently displayed
                VStack(spacing: 30) {
                    // Victory banner
                    VStack(spacing: 10) {
                        Text("🏆 VICTORY! 🏆")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.yellow)
                            .shadow(color: .orange, radius: 5, x: 0, y: 2)
                        
                        Text("\(viewModel.winnerName) Win!")
                            .font(.title)
                            .bold()
                            .foregroundColor(.green)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                    .padding(.top, 50)
                    
                    // Winner profile section
                    if let winner = viewModel.winnerUser {
                        VStack(spacing: 20) {
                            // Profile image with victory effects
                            ZStack {
                                // Golden glow background
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.yellow.opacity(0.8), .orange.opacity(0.6)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 220, height: 220)
                                    .blur(radius: 10)
                                
                                ProfilePhotoHelper.getProfileImageView(for: winner, size: .large)
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.yellow, .orange, .yellow]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 6
                                            )
                                    )
                                    .shadow(color: .yellow.opacity(0.6), radius: 15, x: 0, y: 5)
                            }
                            
                            // Winner's name and stats
                            VStack(spacing: 8) {
                                Text(viewModel.currentUserWon ? winner.username : "Opponent")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.primary)
                                
                                if viewModel.currentUserWon {
                                    HStack(spacing: 20) {
                                        VStack {
                                            Text("Total Wins")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Text("\(winner.numberOfWins + 1)")
                                                .font(.headline)
                                                .bold()
                                                .foregroundColor(.green)
                                        }
                                        
                                        VStack {
                                            Text("Sword")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Image(String(winner.sword))
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .background(Color.black.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Action buttons
                    VStack(spacing: 15) {
//                        Button(action: {
//                            // Handle play again using viewModel
//                            if let newGameVM = viewModel.resetForNewGame() {
//                                // Navigate to new game or handle rematch
//                            }
//                        }) {
//                            Text("⚔️ Duel Again!")
//                                .font(.title2)
//                                .bold()
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 15)
//                                .background(
//                                    LinearGradient(
//                                        gradient: Gradient(colors: [.blue, .purple]),
//                                        startPoint: .leading,
//                                        endPoint: .trailing
//                                    )
//                                )
//                                .cornerRadius(12)
//                                .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 4)
//                        }
                        
                        Button(action: {
                            nav.currentPage = .mainMenu
                        }) {
                            Text("Main Menu")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
                
                // Confetti or sparkle effects (optional)
//                if viewModel.currentUserWon {
//                    VStack {
//                        HStack {
//                            Text("✨")
//                                .font(.title)
//                                .offset(x: -20, y: 100)
//                            Spacer()
//                            Text("🎉")
//                                .font(.title)
//                                .offset(x: 20, y: 80)
//                        }
//                        Spacer()
//                        HStack {
//                            Text("🌟")
//                                .font(.title)
//                                .offset(x: -30, y: -100)
//                            Spacer()
//                            Text("✨")
//                                .font(.title)
//                                .offset(x: 30, y: -120)
//                        }
//                    }
//                    .padding(.horizontal, 50)
//                }
            }
            .onTapGesture {
                navigatetoSummary = true
                NavigationHandler.animatePageChange {
                    nav.currentPage = .login(email: "", password: "")
                }
            }
        }
        .onAppear {
            // Update win count when results appear
            viewModel.updateWinCount()
        }
    }
}
