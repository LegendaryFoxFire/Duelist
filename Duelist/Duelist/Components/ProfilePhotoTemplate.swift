//
//  ProfilePhotoTemplate.swift
//  Duelist
//
//  Created by Sam on 22/07/25.
//

import SwiftUI

enum ProfilePhotoSize {
    case small
    case large
}

struct ProfilePhotoTemplate: View {
    var size: ProfilePhotoSize
    var image: String
    
    var body: some View {
        if size == .small{
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 2)))
        } else if size == .large{
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 4)))
        }
    }
}

#Preview {
    ProfilePhotoTemplate(size: .large, image: "profile_photo_3")
}
