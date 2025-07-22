//
//  ProfilePhotoTemplate.swift
//  Duelist
//
//  Created by Sam on 22/07/25.
//

import SwiftUI

enum ProfilePhotoSize {
    case small
    case medium
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
        } else if size == .medium{
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 3)))
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
    ProfilePhotoTemplate(size: .medium, image: "profile_photo_3")
}
