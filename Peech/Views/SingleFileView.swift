//
//  SingleFileView.swift
//  Peech
//
//  Created by Yuliia on 18/11/23.
//

import SwiftUI
import SwiftData
import AVFoundation



struct SingleFileView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query var files: [ConvertedFile]
    
    var currentFile: ConvertedFile
    private var thumbnailImage: UIImage
    
    @State private var speechSpeed: Float = 1.0
    
    @State private var synthesizer: AVSpeechSynthesizer? = AVSpeechSynthesizer()
    
    @State private var singleFileController: SingleFileController = SingleFileController()
    
    @State private var audioController: AudioController = AudioController()
    
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
        ZStack {
            VStack {
                ScrollView {
                    Text(currentFile.text)
                        .padding(.leading, 20)
                        .padding(.trailing, 5)
                        .multilineTextAlignment(.leading)
                        .accessibilityLabel("Converted Text")
                }.contentMargins(.bottom, 100, for: .scrollContent)
            }
            VStack {
                Spacer()
                HStack(spacing: 17) {
                    playButtonView()
                    VStack(alignment: .leading, spacing: 4) {
                        Text(currentFile.title)
                            .font(.system(size: 19))
                            .fontWeight(.semibold)
                        Text(singleFileController.timerValue.asTimestamp)
                                .font(.system(size: 17))
                                .foregroundStyle(.opacity(0.7))
                                .contentTransition(.numericText())
                                .onChange(of: audioController.audioDuration) {
                                    withAnimation(.default.speed(1)) {
                                        singleFileController.timerValue = audioController.audioDuration
                                        
                                    }
                                }
                    }.accessibilityHidden(true)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .frame(height: 80)
                .background (.regularMaterial, in: RoundedRectangle(cornerRadius: 20.0, style: .continuous))
                
            }
                .padding(.horizontal, 10)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(currentFile.title == "Converted File" ? "Converted File" : currentFile.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // MARK: Back button
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if files.contains(currentFile) {
                        dismiss()
                    } else {
                        singleFileController.isBackButtonPopoverPresented.toggle()
                    }
                    
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: {
                        // "Save File" action
                        print("save button is pressed")
                        singleFileController.isSavePopoverPresented.toggle()
                    }) {
                        Label("Save File", systemImage: "square.and.arrow.down")
                    }
                    
                    Button(action: {
                        // "Copy to Clipboard" action
                        UIPasteboard.general.setValue(currentFile.text, forPasteboardType: "public.plain-text")
                        singleFileController.isCopyAlertPresented.toggle()
                    }) {
                        Label("Copy to Clipboard", systemImage: "doc.on.doc")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                    
                }
                
            }
        }
        //MARK: Alert for saving file from toolbar action
        .alert("Let's save your file", isPresented: $singleFileController.isSavePopoverPresented) {
            TextField("Title", text: $singleFileController.fileTitle)
            Button("Save") {
                print("Saving file with title: \(singleFileController.fileTitle)")
                saveNewFile(fileTitle: singleFileController.fileTitle)
                singleFileController.isSavePopoverPresented.toggle()
                
            }.accessibilityLabel("Save")
            Button("Cancel", role: .cancel) { singleFileController.isSavePopoverPresented.toggle() }
                .accessibilityLabel("Cancel")
        } message: {
            Text("Enter the title of file")
        }
        
        //MARK: Alert for saving file before dissmissing the view
        .alert(
            "Would you like to save your file?",
            isPresented: $singleFileController.isBackButtonPopoverPresented
        ) {
            TextField("Title", text: $singleFileController.fileTitle)
            Button("Save") {
                print("Saving file with title: \(singleFileController.fileTitle)")
                saveNewFile(fileTitle: singleFileController.fileTitle)
                singleFileController.isBackButtonPopoverPresented.toggle()
                dismiss()
            }.accessibilityLabel("Save")
            Button(
                "Cancel",
                role: .cancel
            ) { singleFileController.isBackButtonPopoverPresented.toggle()
                dismiss()
            }
            .accessibilityLabel("Cancel")
        } message: {
            Text("Enter the title of file")
        }
        
        .onDisappear(perform: {
            audioController.stopAudio()
        })
        
        //MARK: Alert for status after saving a file
        .alert(isPresented: $singleFileController.isSaveAlertPresented.isPresented) {
                        Alert(
                            title: Text(singleFileController.isSaveAlertPresented.isSuccess ? "Successfully saved!" : "Couldn't save file"),
                            dismissButton: .default(Text("OK")){
                                // Close the screen when "OK" button is tapped
                                singleFileController.isSaveAlertPresented.isPresented = false
                            }
                        )
                    }
        //MARK: Alert when text is copied
        .alert(isPresented: $singleFileController.isCopyAlertPresented) {
                        Alert(
                            title: Text("Successfully copied!"),
                            dismissButton: .default(Text("OK")){
                                // Close the screen when "OK" button is tapped
                                singleFileController.isCopyAlertPresented = false
                            }
                        )
                    }
    }
    
    private func playButtonView() -> some View {
        Button() {
            if audioController.isPlaying == false {
                print("trying audioController.playAudio")
                audioController.playAudio(text: currentFile.text)
            } else {
                audioController.pauseAudio()
            }
        } label: {
            ZStack {
                ThumbnailView(image: Image(uiImage: thumbnailImage), width: 60, height: 60)
                    .overlay {
                        Rectangle().foregroundStyle(Color.black).opacity(0.5)
                            .cornerRadius(6)
                    }
                Image(systemName: audioController.isPlaying ? "pause.fill" : "play.fill")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 25))
            }
        }.accessibilityLabel(audioController.isPlaying ? "Pause audio" : "Play audio")
    }
    
    private func speedButtonView() -> some View {
        Button() {
            singleFileController.changeAudioSpeed()
        } label: {
            Capsule()
                .frame(width: 55, height: 35)
                .foregroundStyle(.thickMaterial)
                .overlay {
                    Text("1.5x")
                        .font(.callout)
                }
            
        }.buttonStyle(.plain)
        .accessibilityLabel("Change audio speed")
        .sheet(isPresented: $singleFileController.isSpeechRateModalPresented) {
                AudioSpeedModalView(speechRate: $speechSpeed)
                .presentationDetents([.fraction(0.3)])
                .onChange(of: speechSpeed, {audioController.rate = speechSpeed})
              }
    }
    
    private func saveNewFile(fileTitle: String = "Converted File") {
        currentFile.title = fileTitle
        let convertedFile = currentFile
        
        context.insert(convertedFile)
        do {
            try context.save()
            singleFileController.isSaveAlertPresented = (true, true)
        } catch {
            singleFileController.isSaveAlertPresented = (true, false)
            print(error.localizedDescription)
        }
    }
    
}
