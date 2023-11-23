//
//  FileListView.swift
//  Peech
//
//  Created by Yuliia on 14/11/23.
//

import SwiftUI
import SwiftData

struct FileListView: View {
    let files: [ConvertedFile]
    @Environment(\.modelContext) private var context
    
    private func deleteFile(indexSet: IndexSet) {
        indexSet.forEach { index in
            let file = files[index]
            context.delete(file)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(files, id: \.id) { file in
                NavigationLink(value: file) {
                    HStack {
                        if let imageData = file.imageData, let uiImage = UIImage(data: imageData) {
                            ThumbnailView(image: Image(uiImage: uiImage))
                        } else {
                            ThumbnailView(image: Image(systemName: "photo.fill"))
                        }
                        VStack(alignment: .leading) {
                            Text(file.title)
                                .font(.title3)
                                Text(file.creationDate, style: .date)
                                    .font(.caption)
                        }
                    }
                }.accessibilityLabel("Converted File \(file.title)")
                    .accessibilityHint("Tap to open file, swipe left to delete file")
            }.onDelete(perform: deleteFile)
        }
        .accessibilityLabel("List of files")
        .navigationDestination(for: ConvertedFile.self) { file in
            SingleFileView(currentFile: file)
        }
    }
}

#Preview {
    FileListView(files: [ConvertedFile(title: "file 2", text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more rece Lorem Ipsum is simply dummy text of the prinlly unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more rece", imageData: UIImage(systemName: "photo.fill")?.pngData())])
}


