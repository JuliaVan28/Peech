//
//  ImportFilesController.swift
//  Peech
//
//  Created by Yuliia on 20/05/24.
//

import Foundation
import PDFKit

@Observable class ImportFilesController {
    func importPDFFile(fileURL: URL) throws -> (title: String, recognizedText: String, thumbnail: UIImage?)  {
        guard fileURL.startAccessingSecurityScopedResource() else { throw ImportFilesControllerError.errorAccessingSecurityScope  }
        defer { fileURL.stopAccessingSecurityScopedResource() }
        if let pdf = PDFDocument(url: fileURL) {
            print("imported PDF")
            let pageCount = pdf.pageCount
            var documentContent = ""
            let documentAttributes = pdf.documentAttributes!
            let title = documentAttributes[PDFDocumentAttribute.titleAttribute] as? String
            var thumbnail: UIImage = UIImage(systemName: "photo.fill")!
            print("doc title \(String(describing: title))")
            for i in 0 ..< pageCount {
                guard let page = pdf.page(at: i) else { continue }
                guard let pageContent = page.string else { continue }
                thumbnail = page.thumbnail(of: CGSize(width: 50, height: 50), for: .cropBox)
                documentContent.append(pageContent)
            }
            print(documentContent)
            return (title: title ?? "New File", recognizedText: documentContent, thumbnail: thumbnail)
        } else {
            throw ImportFilesControllerError.invalidImport
        }
    }
}
    
enum ImportFilesControllerError: Error {
    case invalidImport
    case errorAccessingSecurityScope
}
