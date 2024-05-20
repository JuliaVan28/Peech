//
//  materialButton.swift
//  Peech
//
//  Created by Yuliia on 10/05/24.
//

import SwiftUI

struct MaterialButton: View {
    var icon: String = "arrow.down.doc"
    var label: String = "Import File"
    
    var body: some View {
            Rectangle()
                .foregroundStyle(.regularMaterial)
                .frame(maxWidth: 172.0,maxHeight: 80.0)
                .clipShape(.rect(cornerRadius: 20.0))
                .overlay(content: {
                    VStack {
                        Image(systemName: icon)
                            .font(.title)
                            .foregroundStyle(.secondary)
                        Text(label)
                            .multilineTextAlignment(.center)
                            .fontWeight(.semibold)
                    }
                })
        }
            
    
}

#Preview {
    MaterialButton()
}
