//
//  ProfilePhotoHelper.swift
//  Duelist
//
//  Created by Sebastian on 7/27/25.
//

import Foundation
import SwiftUI

struct ProfilePhotoHelper {
    static func getProfileImageView(for user: User, size: ProfilePhotoSize) -> some View {
        Group {
            if let customImageURL = user.customProfileImageURL, !customImageURL.isEmpty {
                // Show custom uploaded image
                AsyncImage(url: URL(string: customImageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    // Show preset image while loading
                    Image(ProfilePhotoConstants.getProfileImage(index: user.profilePicture))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            } else {
                // Show preset image
                Image(ProfilePhotoConstants.getProfileImage(index: user.profilePicture))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: getDimension(for: size), height: getDimension(for: size))
        .clipShape(Circle())
    }
    
    private static func getDimension(for size: ProfilePhotoSize) -> CGFloat {
        switch size {
        case .small:
            return 50
        case .medium:
            return 100
        case .large:
            return 150 // You might want to adjust this based on your design
        }
    }
}
