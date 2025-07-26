//
//  SwordPhotoTemplate.swift
//  Duelist
//
//  Created by Sam on 25/07/25.
//

import SwiftUI

//enum SwordPhotoSize {
//    case small
//    case medium
//    case large
//}

struct SwordPhotoTemplate: View {
var image: String

    var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
    }
}
