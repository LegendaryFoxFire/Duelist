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
        D_Background {
        BackButton(label:"Main Menu", destination: .mainMenu) {
            VStack {
                D_Label(title: "Choose Your weapon", fontSize: Globals.LargeTitleFontSize)
                D_List{
                    ForEach(swordList) { sword in
                        D_ListRow {
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
                                        D_Label(title: "Equipped!", fontSize: Globals.HeadingFontSize)
                                        
                                            .foregroundColor(.black)
                                    } else if sword.numWins > userManager.currentUser.numberOfWins {
                                        D_Label(title: "Unlocked at \(sword.numWins) Wins!", fontSize: Globals.HeadingFontSize)
                                            .foregroundColor(.black)
                                    } else{
                                        D_Label(title: "Tap to Equip", fontSize: Globals.HeadingFontSize)
                                            .foregroundColor(.black)
                                    }
                                    
                                }
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
