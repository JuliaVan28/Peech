//
//  PhotoView.swift
//  Peech
//
//  Created by Yuliia on 15/11/23.
//

import SwiftUI
import Photos
import os.log


struct PhotoView: View {
    @StateObject private var textProcessor = TextProcessor()
    
    var asset: PhotoAsset
    
    var cache: CachedImageManager?
    
    @State private var image: Image?
    @State private var uiImage: UIImage?
    @State private var cgImage: CGImage?
    @State private var imageRequestID: PHImageRequestID?
    
    @Environment(\.dismiss) var dismiss
    @State var shouldPresentTextNotFoundAlert: Bool = false
    @State var shouldPresentSingleFileView: Bool = false

    private let imageSize = CGSize(width: 1024, height: 1024)
    
    var body: some View {
        Group {
            if let image = image {
                VStack {
                    Spacer()
                    image
                        .resizable()
                        .scaledToFit()
                        .accessibilityLabel(asset.accessibilityLabel)
                    Spacer()
                    buttonView()
                }
            } else {
                ProgressView()
            }
        }
        .navigationDestination(isPresented: $shouldPresentSingleFileView) {
            
            let imageData = uiImage?.pngData()
            let convertedFile = ConvertedFile(title: "Neew fiel", text: textProcessor.convertedText, imageData: imageData)
            SingleFileView(currentFile: convertedFile)
            .onDisappear(perform: {
                shouldPresentSingleFileView = false
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard image == nil, let cache = cache else { return }
            
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                
                Task {
                    if let result = result {
                        self.uiImage = result.image
                        self.image = Image(uiImage: result.image!)
                        self.cgImage = result.image?.cgImage
                    }
                }
                
            }
        }
    }
    
    private func buttonView()  -> some View {
      Button  {
            Task {
                    await textProcessor.recogniseText(in: cgImage) { recognizedStrings in
                        // Check if the array of recognized strings is not empty
                        if !recognizedStrings.isEmpty {
                            shouldPresentSingleFileView = true
                        } else {
                            shouldPresentTextNotFoundAlert = true
                            print("No text recognized.")
                        }
                    }
                    
                }
        } label: {
            Text("Convert")
                .font(.system(size: 36))
                .fontWidth(.expanded)
                .fontWeight(.medium)
        }
        .foregroundStyle(.white)
        .padding(EdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30))
        .padding(.bottom, 20)
        .background(LinearGradient(colors: [Color.green, Color.blue], startPoint: .leading, endPoint: .trailing))
        .cornerRadius(15)
        .clipShape(.capsule)
        .alert(isPresented: $shouldPresentTextNotFoundAlert) {
            Alert(title: Text("👀"), message: Text("Couldn't find any text, try another photo"), dismissButton: .cancel(Text("OK"), action: { dismiss() }))
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "PhotoView")
