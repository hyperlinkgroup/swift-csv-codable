//
//  ExportManager.swift
//
//
//  Created by Anna Münster on 19.07.22.
//

import Foundation

public class ExportManager {
    
    static var configuration = ExportConfiguration()
    
    public static func setup(_ config: ExportConfiguration) {
        self.configuration = config
    }
    
    
    public static func saveAsCSV<T: Encodable>(_ objects: [T], fileName: String = UUID().uuidString, completion: @escaping(Result<URL, Error>) -> Void) {
        
        do {
            let content = try toCSV(objects)
            saveInDocumentDirectory(data: content, fileName: fileName, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    /**
     Exports data to CSV and stores document in DocumentDirectory
     
     - parameters:
     - data: Data as comma-separated values, including headline e.g. "Name; Age\nJohn;20\Jane;29"
     - fileName: Optional name for the generated file. Default is a unique ID
     - completion: if successful the URL for the generated file is returned, otherwise an ExportError
     */
    public static func saveInDocumentDirectory(data: String, fileName: String = UUID().uuidString, completion: @escaping(Result<URL, Error>) -> Void) {
        // write file & open share view
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { completion(.failure(ExportError.fileManager)); return }
        
        let fileURL = dir.appendingPathComponent(String.localizedStringWithFormat("%@.csv", fileName))
        
        do {
            try data.write(to: fileURL, atomically: false, encoding: .utf8)
            
            completion(.success(fileURL))
        } catch {
            completion(.failure(ExportError.csvWrite(error: error)))
        }
    }
    
    /**
     Exports Array of encodable Objects to a CSV String
     
     - parameters:
     - objects: Array of encodable Objects
     
     - returns:
     - String with CSV content. First Row consists of table header, e.g. "Name; Age\nJohn;20\Jane;29"
     */
    public static func toCSV<T: Encodable>(_ objects: [T]) throws -> String {
        do {
            let encodedDic = try objects.map {
                // we need to cast the dictionaries to arrays, because dictionaries can not be sorted, so key-value-pairs would be messed up
                Array(try $0.dictionary()).sorted { $0.0 < $1.0 }
            }
            
            guard let firstDic = encodedDic.first else {
                throw ExportError.dataIsEmpty
            }
            
            let header = firstDic
                .map { $0.key }
                .joined(separator: configuration.delimiter)
            
            let values = encodedDic.map { objectDic in
                objectDic
                    .map { String(describing: $0.value)
                        .replacingOccurrences(of: "\n", with: "")
                        .replacingOccurrences(of: configuration.delimiter, with: "")
                    }
                    .joined(separator: configuration.delimiter)
            }
           
            return "\(header)\n" + values.joined(separator: "\n")
        } catch {
            throw error as? ExportError ?? .unknown(error: error)
        }
    }
}
