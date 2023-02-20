//
//  ExportManager+SwiftUI.swift
//  
//
//  Created by Anna Münster on 14.02.23.
//

import SwiftUI
import UniformTypeIdentifiers

extension ExportManager {
    /**
     Exports Array of encodable Objects to CSV
     
     - parameters:
     - objects: Array of encodable Objects
     - fileName: Optional name for the generated file. Default is a unique ID
     - completion: if successful the URL for the generated file is returned, otherwise an ExportError
     */
    public static func toCSVDocument<T: Encodable>(_ objects: [T], completion: @escaping(Result<CSVDocument, ExportError>) -> Void) {
        do {
            let content = try toCSV(objects)
            
            completion(.success(CSVDocument(content: content)))
        } catch {
            let error = error as? ExportError ?? .unknown(error: error)
            completion(.failure(error))
        }
    }
}

public struct CSVDocument: FileDocument {
    public static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    
    var content: String
    init(content: String) {
        self.content = content
    }
    
    public init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        content = string
    }
    
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = content.data(using: .utf8) else {
            throw CocoaError(.fileWriteUnknown)
        }
        return FileWrapper(regularFileWithContents: data)
    }
}
