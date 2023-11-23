//
//  SingleFileView.swift
//  Peech
//
//  Created by Yuliia on 18/11/23.
//

import SwiftUI
import AVFoundation



struct SingleFileView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var currentFile: ConvertedFile
    private var thumbnailImage: UIImage
    
    @State var isPlaying: Bool = false
    @State var isPopoverPresented: Bool = false
    @State var fileTitle = ""
    
    let synthesizer = AVSpeechSynthesizer()
    
    init(currentFile: ConvertedFile) {
        self.currentFile = currentFile
        
        if let imageData = currentFile.imageData  {
            let uiImage = UIImage(data: imageData)
            thumbnailImage = uiImage ?? UIImage(systemName: "photo.fill")!
        } else {
            print("currentFile.imageData is nil in init SingleFile")
            thumbnailImage = UIImage(systemName: "photo.fill")!
        }
        
    }
    
    var body: some View {
        VStack {
            ScrollView {
                Text(currentFile.text)
                    .padding(.leading, 20)
                    .padding(.trailing, 5)
                    .accessibilityLabel("Converted Text")
            }
            .overlay(alignment: .bottom) {
                HStack(spacing: 17) {
                    playButtonView()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Audio file title")
                            .font(.system(size: 19))
                            .fontWeight(.semibold)
                        
                        Text("1:46")
                            .font(.system(size: 17))
                            .foregroundStyle(.black.opacity(0.7))
                    }.accessibilityHidden(true)
                    Spacer()
                    speedButtonView()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .frame(height: 100)
                .background (
                    .thinMaterial, in: RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                
                
            }.ignoresSafeArea(edges: .bottom)
            
        }
        .navigationTitle("Converted File")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: {
                        // "Save File" action
                        print("save button is pressed")
                        isPopoverPresented.toggle()
                    }) {
                        Label("Save File", systemImage: "square.and.arrow.down")
                    }
                    
                    Button(action: {
                        // "Copy to Clipboard" action
                        UIPasteboard.general.setValue(currentFile.text, forPasteboardType: "public.plain-text")
                    }) {
                        Label("Copy to Clipboard", systemImage: "doc.on.doc")
                    }
                } label: {
                    Image(systemName: "ellipsis").foregroundStyle(Color.black)
                }
                
            }
        }
        .alert("One more step 🌝", isPresented: $isPopoverPresented) {
           
            TextField("Title", text: $fileTitle)
            Button("Yaay") {
                print("Saving file with title: \(fileTitle)")
                saveNewFile(fileTitle: fileTitle)
                isPopoverPresented.toggle()
                
            }.accessibilityLabel("Save")
            Button("Nope", role: .cancel) { isPopoverPresented.toggle() }
                .accessibilityLabel("Cancel")
        } message: {
            Text("Enter the title of file")
        }
        
        .onDisappear(perform: {
            synthesizer.stopSpeaking(at: .immediate)
            isPlaying = false
        })
    }
    
    private func playButtonView() -> some View {
        Button() {
            if isPlaying == false {
                playAudio()
            } else {
                synthesizer.pauseSpeaking(at: .immediate)
                isPlaying.toggle()
            }
        } label: {
            ZStack {
                ThumbnailView(image: Image(uiImage: thumbnailImage), width: 60, height: 60)
                    .overlay {
                        Rectangle().foregroundStyle(Color.black).opacity(0.5)
                            .cornerRadius(6)
                    }
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 25))
            }
        }.accessibilityLabel(isPlaying ? "Pause audio" : "Play audio")
    }
    
    private func speedButtonView() -> some View {
        Button() {
            
        } label: {
            Capsule()
                .frame(width: 55, height: 35)
                .foregroundStyle(.gray.opacity(0.2))
                .overlay {
                    Text("1.5x")
                        .font(.callout)
                        .foregroundStyle(.black)
                }
        }.accessibilityLabel("Change audio speed")
    }
    
    private func playAudio() {
        isPlaying.toggle()
        
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
        } else {
            let utterance = AVSpeechUtterance(string: currentFile.text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(utterance)
        }
    }
    
    private func saveNewFile(fileTitle: String = "Converted File") {
        currentFile.title = fileTitle
        let convertedFile = currentFile
        
        context.insert(convertedFile)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
