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
    @EnvironmentObject var userManager: CurrentUserManager
    
    @State private var showAlert = false
    @State private var newUsername: String = ""

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
        
        BackButton(label:"Profile", destination: .profile) {
            VStack(spacing: 100){
                VStack{
                    D_Label(title: "Settings", fontSize: Globals.LargeTitleFontSize)

                    ProfilePhotoTemplate(size: .medium, image: userManager.currentUser.image)
                    Menu {
                        ForEach(profilePhotos, id: \.self) { photo in
                            Button(action: {
                                userManager.currentUser.image = photo
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
                }
                VStack {
                    D_Label(title: userManager.currentUser.friendsUserID, fontSize: Globals.SmallTitleFontSize)
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
                                userManager.currentUser.friendsUserID = newUsername
                            }
                            showAlert = false
                        }
                    }
                }
                VStack {
                    D_Label(title: "System Setting", fontSize: Globals.SmallTitleFontSize)
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
                        print("Turn on/off notifications")
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
    ProfileSettings_V()
}
