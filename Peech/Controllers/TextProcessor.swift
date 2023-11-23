//
//  TextProcessor.swift
//  Peech
//
//  Created by Yuliia on 16/11/23.
//

import Foundation
import Vision
import SwiftUI
import AVFoundation

final class TextProcessor: ObservableObject {
    @State var recognizedStrings: [String]?
    var convertedText: String = ""
    
    func recogniseText(in image: CGImage?, completion: @escaping ([String]) -> Void) async  {
        guard let cgImage = image else { 
            completion([])
            return 
        }
        
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: { request, error in
            self.recognizeTextHandler(request: request, error: error, completion: completion)})
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?, completion: ([String]) -> Void) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            completion([])
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        self.recognizedStrings = recognizedStrings
        processRecognizedStrings(recognizedStrings)
        completion(recognizedStrings)
    }
    
    func processRecognizedStrings(_ strings: [String]?) {
        if let recognizedStrings = strings {
            convertedText = recognizedStrings.joined(separator: " ")
        } else {
            print("recognizedStrings is nil")
        }
    }
}
