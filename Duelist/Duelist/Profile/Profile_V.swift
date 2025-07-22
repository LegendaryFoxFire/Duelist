//
//  Profile_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct Profile_V: View {
    @EnvironmentObject var nav: NavigationHandler
    var body: some View {
        
        VStack(spacing: Globals.StandardHSpacing){
            
            VStack{
                Text("Profile")
                    .font(.largeTitle)
                    .bold(true)
                //FIXME: Need to load image from database
                ProfilePhotoTemplate(size: .large, image: "profile_photo_3")
            }
            

            VStack{
                // FIXME: Need to load this stuff from database
                Grid(alignment: .leading, horizontalSpacing: Globals.StandardHSpacing, verticalSpacing: Globals.StandardVSpacing) {
                    GridRow {
                        D_Label(title: "Username: ")
                            .font(.title)
                            .bold()
                        D_Label(title: "Billybob")
                            .font(.title)
                    }
                    GridRow {
                        D_Label(title: "Total Wins: ")
                            .font(.title)
                            .bold()
                        D_Label(title: "123")
                            .font(.title)
                    }
                    GridRow {
                        D_Label(title: "Rank: ")
                            .font(.title)
                            .bold(true)
                        D_Label(title: "123")
                            .font(.title)
                    }
                    GridRow {
                        D_Label(title: "User ID: ")
                            .font(.title)
                            .bold(true)
                        D_Label(title: "U789OI84")
                            .font(.title)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: Globals.CornerRadius)
                        .stroke(Color.black, lineWidth: 2)
                        .background(Color.black.opacity(0.15))
                )
                .padding(.horizontal)
                
                Button("Settings") {
                    nav.currentPage = .settings
                }
                
                Button("Main Menu") {
                    nav.currentPage = .mainMenu
                }
            }
        }
        
    }
}

#Preview {
    Profile_V()
}
