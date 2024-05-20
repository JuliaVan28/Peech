//
//  AudioController.swift
//  Peech
//
//  Created by Yuliia on 18/05/24.
//

import Foundation
import SwiftUI
import AVFoundation

@Observable class AudioController: NSObject {
    
    private var synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var isPlaying: Bool = false
    var audioDuration: Int = 0
    var rate: Float = 0.5
    
    private var totalTextLength: Int = 0
    private var speechProgress: Float = 0.0
    
    private var timer = Timer()
    
    
    
    
    init(synthesizer: AVSpeechSynthesizer) {
        super.init()
        self.synthesizer = synthesizer
        self.synthesizer.delegate = self
        
    }
    
    override init() {
        super.init()
        synthesizer.delegate = self
        
        
    }
    
    func playAudio(text: String) {
        
        isPlaying.toggle()
        
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            startTimer()
            print("didContinue speechSynth, duration is \(audioDuration)")
            
        } else {
            print("creating utterance and speaking in controller")
            let utterance = AVSpeechUtterance(string: text)
            
            utterance.rate = rate
            
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            totalTextLength = text.utf16.count
            let duration = Float(totalTextLength) * utterance.rate
            print("audio duration is \(duration/100)")
            print("utterance rate \(utterance.rate)")
            
            synthesizer.speak(utterance)
            audioDuration = 0
            startTimer()
            print("didStart speechSynth, duration is \(audioDuration)")
            
        }
    }
    
    func pauseAudio() {
        synthesizer.pauseSpeaking(at: .immediate)
        isPlaying.toggle()
        pauseTimer()
        print("didPause speechSynth, duration is \(audioDuration)")
        
    }
    
    func stopAudio() {
        synthesizer.stopSpeaking(at: .immediate)
        isPlaying = false
        setDefaults()
        pauseTimer()
    }
    
}

extension AudioController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let progress: Float = Float(characterRange.location) * 100 / Float(totalTextLength)
        //print("characterRange \(characterRange.length)")
        //print("totalTextLenght \(totalTextLength)")
        // print("progress \(progress)")
        speechProgress = progress / 100
        // print("SpeechProgress \(speechProgress)")
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        
    }
    
}

//MARK: - Timer
extension AudioController {
    
    func setDefaults() {
        audioDuration = 0
    }
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            audioDuration += 1
            print("in startTimer: duration is \(audioDuration)")
        })
    }
    
    func pauseTimer() {
        timer.invalidate()
    }
}
