//
//  PhotoView.swift
//  Peech
//
//  Created by Yuliia on 15/11/23.
//

import SwiftUI
import Photos

struct PhotoView: View {

    var asset: PhotoAsset
  
    var cache: CachedImageManager?

    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    @Environment(\.dismiss) var dismiss
    private let imageSize = CGSize(width: 1024, height: 1024)
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel(asset.accessibilityLabel)
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.ignoresSafeArea()
        .background(Color.white)
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            buttonsView()
                .offset(x: 0, y: -50)
        }
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                    }
                }
            }
        }
    }
    
    private func buttonsView() -> some View {
        HStack {
            
            /*Button {
                Task {
                    await asset.setIsFavorite(!asset.isFavorite)
                }
            } label: {
                Label("Favorite", systemImage: asset.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 24))
            }*/

            Button {
                Task {
                    await asset.delete()
                    await MainActor.run {
                        dismiss()
                    }
                }
            } label: {
                Text("Use photo")
                    .font(.system(size: 36))
                    .fontWidth(.expanded)
                    .bold()
            }
        }
        .foregroundStyle(.white)
        .padding(EdgeInsets(top: 20, leading: 30, bottom: 30, trailing: 30))
        .background(LinearGradient(colors: [Color.green, Color.blue], startPoint: .leading, endPoint: .trailing))
        .cornerRadius(15)
        .clipShape(.capsule)
    }
}

