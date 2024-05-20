//
//  TimerController.swift
//  Peech
//
//  Created by Yuliia on 19/05/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable class SingleFileController {
    
    var isSavePopoverPresented: Bool = false
    var isBackButtonPopoverPresented: Bool = false
    var isSpeechRateModalPresented: Bool = false
    var isSaveAlertPresented: (isPresented: Bool, isSuccess: Bool) = (false, true)
    var isCopyAlertPresented: Bool = false

    
    var fileTitle = ""
    
    var timerValue: Int = 0

    func changeAudioSpeed() {
        isSpeechRateModalPresented = true
    }
    
}
