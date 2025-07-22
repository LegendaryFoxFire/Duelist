//
//  ProfileSettings_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI
import PhotosUI

struct ProfileSettings_V: View {
    @EnvironmentObject var nav: NavigationHandler
    let friend: Friend
    
    var body: some View {
        BackButton(label:"Profile", destination: .profile(friend: friend)) {
            VStack(spacing: 100){
                VStack{
                    Text("Profile Settings")
                        .font(.largeTitle)
                        .bold(true)
                    ProfilePhotoTemplate(size: .medium, image: friend.image)
                    D_Button(action: {
                        print("Logic to Change Profile Photo")
                    }){
                        Text("Edit Profile Photo")
                    }
                }
                VStack {
                    D_Label(title: friend.friendsUserID)
                        .font(.title)
                        .bold(true)
                    D_Button(action: {
                        print("Logic to Change Username")
                    }){
                        Text("Edit Username")
                    }
                }
                VStack {
                    Text("System Settings")
                        .font(.largeTitle)
                        .bold(true)
                    
                    D_Button(action: {
                        print("Turn of/off volume")
                    }){
                        Text("Toggle Volume")
                    }
                    
                    D_Button(action: {
                        print("Change Theme")
                    }){
                        Text("Change Theme")
                    }
                    D_Button(action: {
                        print("Turn of/off notifications")
                    }){
                        Text("Notifications")
                    }
                }
                Spacer()
            }
        }
    }
}
    

#Preview {
    ProfileSettings_V(friend: user09)
}
