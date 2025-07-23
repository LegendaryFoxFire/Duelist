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
    @State private var showAlert = false
    @State private var newUsername: String = ""
    @State var friend: Friend  //FIXME: Needs to be some kind of global variable so changes here persist throughout the app
    @State private var newProfilePhoto: String = ""
    var profilePhotos: [String] = [  //FIXME: Probably need some dynamic list of possible profile photos
        "profile_photo_0",
        "profile_photo_1",
        "profile_photo_2",
        "profile_photo_3",
        "profile_photo_4",
        "profile_photo_5",
        "profile_photo_6",
        "profile_photo_7",
        "profile_photo_8",
        "profile_photo_9",
        "profile_photo_10",
    ]
    
    var body: some View {
        
        BackButton(label:"Profile", destination: .profile(friend: friend)) {
            VStack(spacing: 100){
                VStack{
                    Text("Profile Settings")
                        .font(.largeTitle)
                        .bold(true)
                    ProfilePhotoTemplate(size: .medium, image: friend.image)
                    Menu {
                        ForEach(profilePhotos, id: \.self) { photo in
                            Button(action: {
                                newProfilePhoto = photo
                                friend.image = photo
                            }) {
                                Image(photo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .padding(.vertical, 5)
                            }
                        }
                    } label: {
                        Label("Edit Profile Photo", systemImage: "photo")
                            .font(.headline)
                    }
//                    D_Button(action: {
//                        print("Logic to Change Profile Photo")
//                    }){
//                        Text("Edit Profile Photo")
//                    }
                }
                VStack {
                    D_Label(title: friend.friendsUserID)
                        .font(.title)
                        .bold(true)
                    D_Button(action: {
                        showAlert = true
                    }){
                        Text("Edit Username")
                    }
                    .alert("Enter New Username", isPresented: $showAlert) {
                        TextField("New Username", text: $newUsername)
                        Button("Cancel", role: .cancel) {showAlert = false}
                        Button("OK"){
                            if newUsername != ""{
                                friend.friendsUserID = newUsername
                            }
                            showAlert = false
                        }
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
