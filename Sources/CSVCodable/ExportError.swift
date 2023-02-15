//
//  ExportError.swift
//  
//
//  Created by Anna Münster on 23.09.22.
//

import Foundation

public enum ExportError: LocalizedError {
    case csvWrite(error: Error),
         dataIsEmpty,
         encode(error: Error?),
         fileManager,
         unknown(error: Error)
    
    public var errorDescription: String? {
        switch self {
        case .csvWrite(let error): return "Error writing CSV to file: \(error)"
        case .dataIsEmpty: return "Error: Encoded Data is empty"
        case .encode(let error): return "Error encoding object: \(error?.localizedDescription ?? "Cast to [String: Any] failed")"
        case .fileManager: return "Error finding document directory"
        case .unknown(let error): return "Error: \(error.localizedDescription)"
        }
    }
}
