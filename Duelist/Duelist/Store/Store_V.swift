//
//  Store_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct Store_V: View {
    @EnvironmentObject var nav: NavigationHandler
    
    var body: some View {
        BackButton(label:"Main Menu", destination: .mainMenu) {
            HStack {
                List{
                    ForEach(swordList) { sword in
                        Button{
                            print("Pressed \(sword.name)")
                        } label: {
                            HStack{
                                Image(sword.name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                Spacer()
                                Text(sword.numWins)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Store_V()
}
