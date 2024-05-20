//
//  IntExtension.swift
//  Peech
//
//  Created by Yuliia on 20/05/24.
//

import Foundation

extension Int {
    var asTimestamp: String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60
        
        if hour != 0 {
            return String(format: "%02i:%02i:%02i", hour, minute, second)
        } else {
            return String(format: "%02i:%02i", minute, second)
        }
    }
}
