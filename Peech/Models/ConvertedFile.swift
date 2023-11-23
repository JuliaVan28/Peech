//
//  ConvertedFile.swift
//  Peech
//
//  Created by Yuliia on 21/11/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class ConvertedFile: Identifiable {
    @Attribute(.unique) var id : String = UUID().uuidString
    var title: String
    var text: String
    var creationDate: Date
    @Attribute(.externalStorage) var imageData: Data?
    
    init(id: String = UUID().uuidString, title: String, text: String, imageData: Data?, creationDate: Date = .now) {
        self.id = id
        self.title = title
        self.text = text
        self.imageData = imageData
        self.creationDate = creationDate
    }
}
