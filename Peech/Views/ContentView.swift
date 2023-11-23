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

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                if files.isEmpty {
                    VStack {
                        Spacer()
                        CrookedText(text: "Tap here :)", radius: 80)
                            .fontWeight(.medium)
                            .fontWidth(.expanded)
                            .font(.system(size: 22))
                            .rotationEffect(.degrees(20))
                            .foregroundStyle(LinearGradient(colors: [Color.blue, Color.green], startPoint: .leading, endPoint: .trailing))
                            .padding(.bottom, 11)
                            .padding(.trailing, 10)
                            .accessibilityHidden(true)
                    }.ignoresSafeArea()
                }
                VStack {
            
                    if files.isEmpty {
                        Group {
                            Text("Hello, explorer! 🔎")
                                .font(.title)
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                                .padding(.top, 50)
                            Spacer()
                            Image("no-data")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.9)
                                .accessibilityHidden(true)
                            Spacer()
                            Text("Let's create your first text-to-speech file! ")
                                .font(.title)
                                .fontWeight(.regular)
                                .fontWidth(.expanded)
                            Spacer()
                            
                        }
                    } else {
                        FileListView(files: files)
                            .navigationTitle("My Converted Files")
                    }
                    NavigationLink {
                        CameraView()
                    } label: {
                        plusButtonView()
                    }
                    .clipShape(Circle())
                    .accessibilityLabel("Open camera")
                }
                    .padding(.bottom, 20)
            }
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
