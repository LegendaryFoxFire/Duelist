//
//  Store_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct Store_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var userManager: CurrentUserManager
    
    @State private var swordList = [
        Sword(name: "sword_0", numWins: 0),
        Sword(name: "sword_1", numWins: 10),
        Sword(name: "sword_2", numWins: 50),
        Sword(name: "sword_3", numWins: 100),
        Sword(name: "sword_4", numWins: 500)
    ]
    
    var body: some View {
        BackButton(label:"Main Menu", destination: .mainMenu) {
            HStack {
                List{
                    HStack{
                        Text("Swords")
                            .font(.headline)
                        Spacer()
                        Text("Number of Wins to Unlock")
                            .font(.headline)
                    }
                    ForEach(swordList) { sword in
                        Button{
                            if sword.numWins <= userManager.currentUser.numberOfWins {
                                userManager.currentUser.sword = sword.name
                            }
                        } label: {
                            HStack{
                                Image(sword.name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                Spacer()
                                if sword.name == userManager.currentUser.sword {
                                    Text("Equipped!")
                                        .foregroundColor(.black)
                                } else if sword.numWins > userManager.currentUser.numberOfWins {
                                    Text("Unlocked at \(sword.numWins) Wins!")
                                        .foregroundColor(.black)
                                } else{
                                    Text("Tap to Equip")
                                        .foregroundColor(.black)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            updateSwordList()
        }
    }
    
    func updateSwordList(){
        for i in 0..<swordList.count {
            if swordList[i].numWins > userManager.currentUser.numberOfWins {
                swordList[i].name = "\(swordList[i].name)_gs"
            }
        }
    }
}

#Preview {
    Store_V()
}
