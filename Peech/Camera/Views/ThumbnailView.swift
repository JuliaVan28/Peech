//
//  ThumbnailView.swift
//  Peech
//
//  Created by Yuliia on 15/11/23.
//

import SwiftUI

struct ThumbnailView: View {
    var image: Image?
    var width: CGFloat = 50
    var height: CGFloat = 50
    
    var body: some View {
        ZStack {
            Color.white
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: width, height: height)
        .cornerRadius(6)
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static let previewImage = Image(systemName: "photo.fill")
    static var previews: some View {
        ThumbnailView(image: previewImage)
    }
}
