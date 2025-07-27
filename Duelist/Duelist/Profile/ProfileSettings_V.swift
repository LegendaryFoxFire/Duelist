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
    @EnvironmentObject var authManager: AuthManager
    
    @State private var showCameraError = false
    @State private var cameraErrorMessage = ""
    
    @State private var showUsernameAlert = false
    @State private var newUsername: String = ""
    @State var picNum = 0
    @State private var isShowingCamera = false
    @State private var isUpdating = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showThemeSelector = false

    @State private var newProfilePhoto: String = ""
    
    // Available themes
    private let availableThemes = ["Default", "Dark", "Light", "Ocean", "Forest"]

    var body: some View {
        D_Background {
            BackButton(label:"Profile", destination: .profile) {
                settingsContent
            }
            .padding(.top, 50)
        }
        .sheet(isPresented: $isShowingCamera) {
            CameraImagePicker(
                isPresented: $isShowingCamera,
                onImagePicked: { image in
                    handleCapturedImage(image)
                },
                onError: { errorMessage in
                    cameraErrorMessage = errorMessage
                    showCameraError = true
                }
            )
        }
        .alert("Camera Error", isPresented: $showCameraError) {
            Button("OK") { }
            Button("Settings") {
                // Open app settings
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        } message: {
            Text(cameraErrorMessage)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .alert("Change Username", isPresented: $showUsernameAlert) {
            TextField("New Username", text: $newUsername)
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                if !newUsername.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    updateUsername(newName: newUsername)
                }
            }
        } message: {
            Text("Enter your new username")
        }
        .alert("Select Theme", isPresented: $showThemeSelector) {
            ForEach(availableThemes, id: \.self) { theme in
                Button(theme) {
                    updateTheme(newTheme: theme)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Choose your preferred theme")
        }
    }
    
    @ViewBuilder
    private var settingsContent: some View {
        if let currentUser = authManager.user {
            VStack(spacing: 100) {
                VStack {
                    D_Label(title: "Settings", fontSize: Globals.LargeTitleFontSize)
                    
                    ProfilePhotoHelper.getProfileImageView(for: currentUser, size: .medium)
                    
                    Menu {
                        ForEach(ProfilePhotoConstants.profilePhotos.indices, id: \.self) { index in
                            let photo = ProfilePhotoConstants.profilePhotos[index]
                            Button(action: {
                                updateProfilePicture(index: index)
                            }) {
                                Text("Profile Picture \(index)")
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
                    .disabled(isUpdating)
                    .padding(.bottom)
                    
                    Button {
                        isShowingCamera = true
                    } label: {
                        Label("Take Profile Photo", systemImage: "camera")
                            .font(.headline)
                    }
                    .disabled(isUpdating)
                    
                    // Add this toggle - only show if user has a custom image
                    if currentUser.customProfileImageURL != nil && !currentUser.customProfileImageURL!.isEmpty {
                        D_Button(action: {
                            toggleCustomProfileImage()
                        }) {
                            HStack {
                                Image(systemName: currentUser.useCustomProfileImage ? "person.crop.circle.fill" : "person.crop.circle")
                                Text(currentUser.useCustomProfileImage ? "Using Custom Photo" : "Using Default Photo")
                            }
                        }
                        .disabled(isUpdating)
                        .padding(.top)
                    }
                }
                
                VStack {
                    D_Label(title: currentUser.username, fontSize: Globals.SmallTitleFontSize)
                        .font(.title)
                        .bold(true)
                    
                    D_Button(action: {
                        newUsername = currentUser.username
                        showUsernameAlert = true
                    }) {
                        Group {
                            if isUpdating {
                                HStack {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                    Text("Updating...")
                                }
                            } else {
                                Text("Edit Username")
                            }
                        }
                    }
                    .disabled(isUpdating)
                }
                
                VStack {
                    D_Label(title: "System Settings", fontSize: Globals.SmallTitleFontSize)
                        .font(.largeTitle)
                        .bold(true)
                    
                    // Volume Toggle
                    D_Button(action: {
                        toggleVolume()
                    }) {
                        HStack {
                            Image(systemName: currentUser.volumeOn ? "speaker.wave.2" : "speaker.slash")
                            Text(currentUser.volumeOn ? "Volume: On" : "Volume: Off")
                        }
                    }
                    .disabled(isUpdating)
                    
                    // Theme Selector
                    D_Button(action: {
                        showThemeSelector = true
                    }) {
                        HStack {
                            Image(systemName: "paintpalette")
                            Text("Theme: \(currentUser.theme)")
                        }
                    }
                    .disabled(isUpdating)
                    
                    // Notifications Toggle
                    D_Button(action: {
                        toggleNotifications()
                    }) {
                        HStack {
                            Image(systemName: currentUser.notificationsOn ? "bell" : "bell.slash")
                            Text(currentUser.notificationsOn ? "Notifications: On" : "Notifications: Off")
                        }
                    }
                    .disabled(isUpdating)
                    
                    // Sign Out Button
                    D_Button(action: {
                        signOut()
                    }){
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
                Spacer()
            }
        } else {
            // Loading state
            VStack {
                ProgressView("Loading Settings...")
                    .font(.title2)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // Update profile picture
    private func updateProfilePicture(index: Int) {
        guard let currentUser = authManager.user else { return }
        
        Task {
            do {
                await MainActor.run { isUpdating = true }
                
                var updatedUser = currentUser
                updatedUser.profilePicture = index
                
                try await authManager.updateUser(updatedUser)
                
                await MainActor.run {
                    isUpdating = false
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to update profile picture: \(error.localizedDescription)"
                    showError = true
                    isUpdating = false
                }
            }
        }
    }
    
    // Update username
    private func updateUsername(newName: String) {
        guard let currentUser = authManager.user else { return }
        
        Task {
            do {
                await MainActor.run { isUpdating = true }
                
                var updatedUser = currentUser
                updatedUser.username = newName
                
                try await authManager.updateUser(updatedUser)
                
                await MainActor.run {
                    isUpdating = false
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to update username: \(error.localizedDescription)"
                    showError = true
                    isUpdating = false
                }
            }
        }
    }
    
    // Toggle volume setting
    private func toggleVolume() {
        guard let currentUser = authManager.user else { return }
        
        Task {
            do {
                await MainActor.run { isUpdating = true }
                
                var updatedUser = currentUser
                updatedUser.volumeOn.toggle()
                
                try await authManager.updateUser(updatedUser)
                
                await MainActor.run {
                    isUpdating = false
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to update volume setting: \(error.localizedDescription)"
                    showError = true
                    isUpdating = false
                }
            }
        }
    }
    
    // Update theme
    private func updateTheme(newTheme: String) {
        guard let currentUser = authManager.user else { return }
        
        Task {
            do {
                await MainActor.run { isUpdating = true }
                
                var updatedUser = currentUser
                updatedUser.theme = newTheme
                
                try await authManager.updateUser(updatedUser)
                
                await MainActor.run {
                    isUpdating = false
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to update theme: \(error.localizedDescription)"
                    showError = true
                    isUpdating = false
                }
            }
        }
    }
    
    // Toggle notifications setting
    private func toggleNotifications() {
        guard let currentUser = authManager.user else { return }
        
        Task {
            do {
                await MainActor.run { isUpdating = true }
                
                var updatedUser = currentUser
                updatedUser.notificationsOn.toggle()
                
                try await authManager.updateUser(updatedUser)
                
                await MainActor.run {
                    isUpdating = false
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to update notifications setting: \(error.localizedDescription)"
                    showError = true
                    isUpdating = false
                }
            }
        }
    }
    
    // Handle captured image from camera
    private func handleCapturedImage(_ image: UIImage) {
        Task {
            do {
                await MainActor.run { isUpdating = true }
                
                // Upload and save the custom profile image
                try await authManager.uploadCustomProfileImage(image)
                
                await MainActor.run {
                    isUpdating = false
                    // Image is now saved and UI will update automatically
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to upload image: \(error.localizedDescription)"
                    showError = true
                    isUpdating = false
                }
            }
        }
    }
    
    // Add this method to ProfileSettings_V
    private func toggleCustomProfileImage() {
        Task {
            do {
                await MainActor.run { isUpdating = true }
                
                try await authManager.toggleCustomProfileImage()
                
                await MainActor.run {
                    isUpdating = false
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to update profile photo setting: \(error.localizedDescription)"
                    showError = true
                    isUpdating = false
                }
            }
        }
    }
    
    // Sign out function
    private func signOut() {
        do {
            try authManager.signOut()
            NavigationHandler.animatePageChange {
                nav.currentPage = .login(email: "", password: "")
            }
        } catch {
            errorMessage = "Failed to sign out: \(error.localizedDescription)"
            showError = true
        }
    }
}



#Preview {
    ProfileSettings_V()
}
