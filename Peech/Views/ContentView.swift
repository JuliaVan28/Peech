//
//  ContentView.swift
//  Peech
//
//  Created by Yuliia on 14/11/23.
//

import SwiftUI
import SwiftData
import CrookedText

struct ContentView: View {
    @Query(sort: \ConvertedFile.id, order: .reverse) private var files: [ConvertedFile]
    @Environment(\.dismiss) var dismiss

    @State private var isImportingFiles = false
    @State private var shouldPresentScannerView: Bool = false
    @State private var shouldPresentSingleFileView: Bool = false
    @State private var shouldPresentTextNotFoundAlert: Bool = false
        
    @State private var convertedFile: ConvertedFile?
    @State private var recognisedStrings: [String] = []

    
    var body: some View {
        NavigationStack {
            
            if files.isEmpty {
                VStack {
                    ZStack {
                        VStack {
                            Spacer()
                            Image("tall-wave")
                            // .blur(radius: 10)
                                .opacity(0.65)
                                .overlay(content: {
                                    VStack{
                                        Spacer()
                                        Image("short-wave")
                                            .opacity(0.7)
                                    }
                                })
                            
                        }.ignoresSafeArea()
                        
                        Group {
                            VStack {
                                Spacer().frame(maxHeight: 180)
                                Text("**Hello 👋** **SpeechWave** is here to help you convert any **text to speech** 🗣️")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                Spacer()
                                HStack {
                                    Button {
                                        isImportingFiles = true

                                    } label: {
                                        MaterialButton(icon: "arrow.down.doc.fill", label: "Upload File")
                                    }
                                    .fileImporter(
                                                isPresented: $isImportingFiles,
                                                allowedContentTypes: [.plainText]
                                            ) { result in
                                                switch result {
                                                case .success(let file):
                                                    print(file.absoluteString)
                                                case .failure(let error):
                                                    print(error.localizedDescription)
                                                }
                                            }
                                    .buttonStyle(PlainButtonStyle())
                                    .accessibilityLabel("Upload File")
                                    
                                    //Text Scanner
                                    Button {
                                        print("scan text is tapped")
                                        shouldPresentScannerView = true
                                    } label: {
                                        MaterialButton(icon: "camera.on.rectangle.fill", label: "Scan Text")
                                    }
                                        .navigationDestination(isPresented: $shouldPresentSingleFileView) {
                                            if let convertedFile = convertedFile {
                                                
                                                SingleFileView(currentFile: convertedFile)
                                                    .onDisappear {
                                                        print(files.count)
                                                        shouldPresentScannerView = false

                                                        shouldPresentSingleFileView = false
                                                        print(" shouldPresentScannerView \(shouldPresentScannerView)")
                                                        print(" shouldPresentSingleFileView \(shouldPresentSingleFileView)")

                                                    }
                                            }

                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .accessibilityLabel("Scan Text")
                                    
                                }
                                                                
                            }.padding(.horizontal, 20)
                        }
                    }
                }
            } else {
                FileListView(files: files)
                    .navigationTitle("My Converted Files")
            }
        }.sheet(isPresented: $shouldPresentScannerView) {
            ScannerView() { result in
                switch result {
                case .success(let scannedImages):
                    self.recognisedStrings = []
                    TextProcessor( recognizedStrings: $recognisedStrings, scannedImages: scannedImages) {
                        print("back in contentView")
                        if recognisedStrings.isEmpty {
                            shouldPresentTextNotFoundAlert = true
                            print("No text recognized.")
                        } else {
                            let convertedText = recognisedStrings.joined(separator: " ")
                            let thumbnailImageData = scannedImages.first?.pngData()
                            
                            self.convertedFile = ConvertedFile(title: recognisedStrings.first ?? "Converted File", text: convertedText, imageData: thumbnailImageData)
                            
                            shouldPresentSingleFileView = true
                            
                        }
                    }.recogniseText()
                    print("success")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                shouldPresentScannerView = false
                
            } didCancelScanning: {
                print("Canceled scanning")
                shouldPresentScannerView = false
            }
            
        }
        .alert(isPresented: $shouldPresentTextNotFoundAlert) {
            Alert(title: Text("👀"), message: Text("Couldn't find any text, try another photo"), dismissButton: .cancel(Text("OK"), action: { dismiss() }))
        }
    }
    
    private func plusButtonView() -> some View {
        Circle()
            .frame(width: 100, height: 100)
            .overlay {
                ZStack {
                    LinearGradient(colors: [Color.green, Color.blue], startPoint: .leading, endPoint: .trailing)
                    Image(systemName: "plus")
                        .font(.system(size: 50))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.white)
                }
            }
    }
    
}

#Preview {
    ContentView()
}
