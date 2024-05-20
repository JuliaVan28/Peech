//
//  ContentView.swift
//  Peech
//
//  Created by Yuliia on 14/11/23.
//

import SwiftUI
import SwiftData
import PDFKit

struct ContentView: View {
    @Query(sort: \ConvertedFile.id, order: .reverse) private var files: [ConvertedFile]
    @Environment(\.dismiss) var dismiss
    
    @State private var importFilesController = ImportFilesController()
    
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
                                    //File import
                                    importButtonView(myLabel: MaterialButton(icon: "arrow.down.doc.fill", label: "Import File"))
                                    
                                    //Text Scanner
                                    Button {
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
                ZStack {
                    FileListView(files: files)
                        .navigationTitle("Converted Files")
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()

                            importButtonView(myLabel:
                            HStack(spacing: 5) {
                                Image(systemName: "arrow.down.doc.fill")
                                    .foregroundStyle(.orange.opacity(0.8))
                                    .font(.title3)
                                    
                                Text("Import file")
                                    .multilineTextAlignment(.center)
                                    .fontWeight(.regular)
                            })
                            .padding()
                            
                            Spacer()
                            Divider().frame(height: 40)
                            Spacer()
                            
                            Button {
                                shouldPresentScannerView = true
                            } label: {
                                HStack(spacing: 5) {
                                    Image(systemName: "camera.on.rectangle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.orange.opacity(0.8))
                                    Text("Scan text")
                                        .multilineTextAlignment(.center)
                                        .fontWeight(.regular)
                                }
                            }
                            .buttonStyle(.plain)
                            .padding()
                            
                            Spacer()

                        }

                        .frame(height: 60)
                        .background (.regularMaterial, in: RoundedRectangle(cornerRadius: 20.0, style: .continuous))
                        
                    }
                    .padding(.horizontal, 20)
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
                }
            }
        }
        .sheet(isPresented: $shouldPresentScannerView) {
            ScannerView() { result in
                switch result {
                case .success(let scannedImages):
                    self.recognisedStrings = []
                    TextProcessor( recognizedStrings: $recognisedStrings, scannedImages: scannedImages) {
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
    
    private func importButtonView(myLabel: some View) -> some View {
        Button {
            isImportingFiles = true
            
        } label: {
            myLabel
        }
        .fileImporter(
            isPresented: $isImportingFiles,
            allowedContentTypes: [.pdf]
        ) { result in
            switch result {
            case .success(let fileURL):
                do {
                    let pdfContent = try importFilesController.importPDFFile(fileURL: fileURL)
                    
                    self.convertedFile = ConvertedFile(title: pdfContent.title, text: pdfContent.recognizedText, imageData: pdfContent.thumbnail?.pngData())
                    
                    shouldPresentSingleFileView = true
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print("failure to get result success")
                print(error.localizedDescription)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Import File")
    }

    
}

#Preview {
    ContentView()
}
