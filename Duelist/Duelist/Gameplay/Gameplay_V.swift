//
//  Gameplay_V.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

import SwiftUI

struct GameplayView: View {
    @ObservedObject var viewModel: GameplayVM
    @StateObject var motion: motion
    @EnvironmentObject var authManager: AuthManager
    @State private var opponentUser: User? = nil

    var body: some View {
        if let winner = viewModel.winner {
            DuelResults_V(viewModel: DuelResults_VM(winnerName: viewModel.winner!, currentUser: authManager.user, opponentUser: opponentUser, authManager: authManager))
                .task {
                        if opponentUser == nil { // Prevent reloading
                            FirebaseService.shared.getUser(by: viewModel.opponent) { result in
                                switch result {
                                case .success(let user):
                                    self.opponentUser = user
                                case .failure(let error):
                                    print("Failed to get user: \(error)")
                                }
                            }
                        }
                    }
        } else {
            ZStack {
                D_Background {
                    Color.clear
                }
                
                VStack {
                    HStack {
                        Text("Opponent: \(viewModel.opponentHealth) HP")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                        Spacer()
                        Text("Action: \(viewModel.opponentAction.rawValue.capitalized)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    ZStack {
                        if viewModel.isBlocking {
                            Image("shield")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                                .foregroundColor(.blue)
                                .shadow(color: .blue.opacity(0.6), radius: 20, x: 0, y: 0)
                                .scaleEffect(viewModel.isBlocking ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.isBlocking)
                        } else {
                            if let currentUser = authManager.user {
                                Image(String(currentUser.sword))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300, height: 300)
                                    .rotationEffect(.degrees(viewModel.swordAngle))
                                    .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 5)
                            } else {
                                Image("sword_0_tp_b")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300, height: 300)
                                    .foregroundColor(.orange)
                                    .rotationEffect(.degrees(viewModel.swordAngle))
                                    .shadow(color: .orange.opacity(0.8), radius: 15, x: 0, y: 5)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Your Health")
                                .font(.headline)
                                .bold()
                            Spacer()
                            Text("\(viewModel.localHealth) HP")
                                .font(.headline)
                                .bold()
                                .foregroundColor(healthColor(for: viewModel.localHealth))
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 20)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [
                                            healthColor(for: viewModel.localHealth),
                                            healthColor(for: viewModel.localHealth).opacity(0.8)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                                    .frame(
                                        width: geometry.size.width * healthPercentage(for: viewModel.localHealth),
                                        height: 20
                                    )
                                    .animation(.easeInOut(duration: 0.5), value: viewModel.localHealth)
                            }
                        }
                        .frame(height: 20)
                        
                        Text("Action: \(viewModel.myAction)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                }
            }
//            .onChange(of: viewModel.myAction) { action in
//
//            }
        }
    }
    
    private func healthColor(for health: Int) -> Color {
        let maxHealth = 30
        let percentage = Double(health) / Double(maxHealth)
        
        if percentage > 0.6 {
            return .green
        } else if percentage > 0.3 {
            return .orange
        } else {
            return .red
        }
    }
    
    private func healthPercentage(for health: Int) -> Double {
        let maxHealth = 30 
        return max(0, min(1, Double(health) / Double(maxHealth)))
    }
}
