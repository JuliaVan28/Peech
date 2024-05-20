//
//  AudioSpeedModalView.swift
//  Peech
//
//  Created by Yuliia on 20/05/24.
//

import Foundation
import SwiftUI

struct AudioSpeedModalView: View {
  @Binding var speechRate: Float
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    VStack(spacing: 20) {
      Text("Speech Rate")
        .font(.headline)
      Slider(value: $speechRate, in: 1.0...2.0, step: 0.25)
      Button("Close") {
        presentationMode.wrappedValue.dismiss()
      }
    }
    .padding()
  }
}
