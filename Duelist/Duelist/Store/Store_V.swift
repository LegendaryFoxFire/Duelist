//
//  Store_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct Store_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var authManager: AuthManager
    
    @State private var swordList = [
        Sword(name: "sword_0_tp", numWins: 0),
        Sword(name: "sword_1_tp", numWins: 10),
        Sword(name: "sword_2_tp", numWins: 50),
        Sword(name: "sword_3_tp", numWins: 100),
        Sword(name: "sword_4_tp", numWins: 500)
    ]
    
    @State private var isUpdating = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        D_Background {
            BackButton(label:"Main Menu", destination: .mainMenu) {
                VStack {
                    D_Label(title: "Choose Your weapon", fontSize: Globals.LargeTitleFontSize)
                    
                    if let currentUser = authManager.user {
                        D_List {
                            ForEach(swordList) { sword in
                                D_ListRow {
                                    Button {
                                        if sword.numWins <= currentUser.numberOfWins {
                                            updateUserSword(swordName: sword.name)
                                        }
                                    } label: {
                                        HStack {
                                            Image(sword.name)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                            Spacer()
                                            
                                            if sword.name == currentUser.sword {
                                                D_Label(title: "Equipped!", fontSize: Globals.HeadingFontSize)
                                                    .foregroundColor(.black)
                                            } else if sword.numWins > currentUser.numberOfWins {
                                                D_Label(title: "Unlocked at \(sword.numWins) Wins!", fontSize: Globals.HeadingFontSize)
                                                    .foregroundColor(.black)
                                            } else {
                                                if isUpdating {
                                                    ProgressView()
                                                        .scaleEffect(0.8)
                                                } else {
                                                    D_Label(title: "Tap to Equip", fontSize: Globals.HeadingFontSize)
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                    }
                                    .disabled(isUpdating || sword.numWins > currentUser.numberOfWins)
                                }
                            }
                        }
                    } else {
                        // Loading state
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
        .onAppear {
            updateSwordList()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    func updateSwordList() {
        guard let currentUser = authManager.user else { return }
        
        for i in 0..<swordList.count {
            if swordList[i].numWins > currentUser.numberOfWins {
                swordList[i].name = "\(swordList[i].name)_b"
            }
        }
    }
    
    func updateUserSword(swordName: String) {
        guard let currentUser = authManager.user else { return }
        
        Task {
            do {
                isUpdating = true
                
                var updatedUser = currentUser
                updatedUser.sword = swordName
                
                try await authManager.updateUser(updatedUser)
                
                await MainActor.run {
                    isUpdating = false
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to update sword: \(error.localizedDescription)"
                    showError = true
                    isUpdating = false
                }
            }
        }
    }
}
