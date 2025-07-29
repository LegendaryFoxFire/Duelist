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
    @State private var showRematchAlert: Bool = false 
    
    var body: some View {
        D_Background {
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 15) {
                    if viewModel.currentUserWon {
                        Text("🏆 VICTORY! 🏆")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.yellow)
                            .shadow(color: .orange, radius: 5, x: 0, y: 2)
                        
                        Text("You Win!")
                            .font(.title)
                            .bold()
                            .foregroundColor(.green)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    } else {
                        Text("💔 DEFEAT 💔")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.red)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                        
                        Text("You Lost...")
                            .font(.title)
                            .bold()
                            .foregroundColor(.red)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
                
                if let currentUser = viewModel.currentUser {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: viewModel.currentUserWon ?
                                            [.yellow.opacity(0.8), .orange.opacity(0.6)] :
                                            [.red.opacity(0.6), .purple.opacity(0.4)]
                                        ),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 220, height: 220)
                                .blur(radius: 10)
                            
                            ProfilePhotoHelper.getProfileImageView(for: currentUser, size: .large)
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: viewModel.currentUserWon ?
                                                    [.yellow, .orange, .yellow] :
                                                    [.red, .purple, .red]
                                                ),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 6
                                        )
                                )
                                .shadow(
                                    color: viewModel.currentUserWon ?
                                        .yellow.opacity(0.6) : .red.opacity(0.6),
                                    radius: 15, x: 0, y: 5
                                )
                        }
                        
                        VStack(spacing: 8) {
                            Text(currentUser.username)
                                .font(.title)
                                .bold()
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 12) {
                                HStack(spacing: 20) {
                                    VStack {
                                        Text("Total Wins")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text("\(viewModel.currentUserWon ? currentUser.numberOfWins + 1 : currentUser.numberOfWins)")
                                            .font(.headline)
                                            .bold()
                                            .foregroundColor(viewModel.currentUserWon ? .green : .primary)
                                    }
                                    
                                    VStack {
                                        Text("Sword")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Image(String(currentUser.sword))
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    }
                                }
                                
                                VStack(spacing: 8) {
                                    HStack {
                                        Text(viewModel.actionStats.playStyle.emoji)
                                            .font(.title2)
                                        Text(viewModel.actionStats.playStyle.rawValue)
                                            .font(.headline)
                                            .bold()
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Text(viewModel.actionStats.playStyle.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                    
                                    if viewModel.actionStats.totalActions > 0 {
                                        VStack(spacing: 8) {
                                            HStack {
                                                Text("⚔️")
                                                    .font(.caption)
                                                GeometryReader { geometry in
                                                    ZStack(alignment: .leading) {
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .fill(Color.gray.opacity(0.3))
                                                            .frame(height: 8)
                                                        
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .fill(Color.red.opacity(0.8))
                                                            .frame(
                                                                width: geometry.size.width * (viewModel.actionStats.attackPercentage / 100),
                                                                height: 8
                                                            )
                                                    }
                                                }
                                                .frame(height: 8)
                                                
                                                Text("\(viewModel.actionStats.attackCount)")
                                                    .font(.caption2)
                                                    .bold()
                                                    .frame(width: 20)
                                            }
                                            
                                            HStack {
                                                Text("🛡️")
                                                    .font(.caption)
                                                GeometryReader { geometry in
                                                    ZStack(alignment: .leading) {
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .fill(Color.gray.opacity(0.3))
                                                            .frame(height: 8)
                                                        
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .fill(Color.blue.opacity(0.8))
                                                            .frame(
                                                                width: geometry.size.width * (viewModel.actionStats.blockPercentage / 100),
                                                                height: 8
                                                            )
                                                    }
                                                }
                                                .frame(height: 8)
                                                
                                                Text("\(viewModel.actionStats.blockCount)")
                                                    .font(.caption2)
                                                    .bold()
                                                    .frame(width: 20)
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 5)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                } else {
                    VStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 200, height: 200)
                        
                        Text("Player")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    Button(action: {
                        handleRematchRequest()
                    }) {
                        Text("⚔️ Request Rematch")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    
                    Button(action: {
                        NavigationHandler.animatePageChange {
                            nav.currentPage = .mainMenu
                        }
                    }) {
                        Text("🏠 Main Menu")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                
                if viewModel.currentUserWon {
                    HStack(spacing: 20) {
                        Text("🎉")
                            .font(.title)
                        Text("✨")
                            .font(.title)
                        Text("🌟")
                            .font(.title)
                        Text("✨")
                            .font(.title)
                        Text("🎉")
                            .font(.title)
                    }
                    .padding(.bottom, 20)
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.updateWinCount()
        }
        .onChange(of: viewModel.shouldStartNewGame) { shouldStart in
            if shouldStart {
                showRematchAlert = true
            }
        }
        .alert("Rematch Request", isPresented: $showRematchAlert) {
            Button("Accept") {
                acceptRematch()
            }
            Button("Decline", role: .cancel) {
                declineRematch()
            }
        } message: {
            Text("Your opponent wants a rematch! Do you accept?")
        }
    }
    
    private func handleRematchRequest() {
        viewModel.startReplay()
        navigateToGameplay()
    }
    
    private func acceptRematch() {
        viewModel.shouldStartNewGame = false
        navigateToGameplay()
    }
    
    private func declineRematch() {
        viewModel.shouldStartNewGame = false
    }
    
    private func navigateToGameplay() {
        NavigationHandler.animatePageChange {
            nav.currentPage = .gameScreen
        }
    }
}
