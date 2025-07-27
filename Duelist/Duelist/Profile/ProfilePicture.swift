//
//  ProfilePicture.swift
//  Duelist
//
//  Created by Sebastian on 7/27/25.
//

import Foundation

struct ProfilePhotoConstants {
    static let profilePhotos = [
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
    
    static func getProfileImage(index: Int) -> String {
        guard index >= 0 && index < profilePhotos.count else {
            return profilePhotos[0]
        }
        return profilePhotos[index]
    }
}
