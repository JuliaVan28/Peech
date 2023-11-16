//
//  FileListView.swift
//  Peech
//
//  Created by Yuliia on 14/11/23.
//

import SwiftUI

struct FileListView: View {
    @State private var image: Image? = Image("frog")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    
    var body: some View {
        
        NavigationStack {
            NavigationLink {
                CameraView()
            } label: {
                Text("Take a photo").foregroundStyle(Color.black)
        }
        }
    }
}

#Preview {
    FileListView()
}
