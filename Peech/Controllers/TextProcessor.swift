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


struct TextProcessor {
    @Binding var recognizedStrings: [String]
    var scannedImages: [UIImage]
    
    var didFinishRecognition: () -> ()
    
    func recogniseText()  {
        print("in recogniseText")
        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        queue.async {
            for image in scannedImages {
                print("processing image")
                
                guard let cgImage = image.cgImage else {
                    return
                }
                
                do {
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage)
                    
                    // Perform the text-recognition request.
                    try requestHandler.perform([createRecognitionRequest()])
                    
                } catch {
                    print("Unable to perform the requests: \(error).")
                }
                
                
            }
            DispatchQueue.main.async {
                print("calling didFinishRecognition")
                didFinishRecognition()
            }
        }
        
    }
    
    private func createRecognitionRequest() -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let observations =
                    request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            observations.forEach { observation in
                guard let recognizedText = observation.topCandidates(1).first else { return }
                
                self.recognizedStrings.append(recognizedText.string)
                print("recognized Strings \(self.recognizedStrings)")
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        return request
    }
    
}
