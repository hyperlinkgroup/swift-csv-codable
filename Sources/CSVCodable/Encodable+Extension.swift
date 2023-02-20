//
//  Encodable.swift
//  
//
//  Created by Anna Münster on 20.07.22.
//

import Foundation

extension Encodable {
    /**
     Creates a dictionary of Key-Value-Pairs (property names and property values) for every encodable object.
     
     - Important:
     Throws an error if the class implements Firebase-specific properties, like @DocumentID. Maybe specific CodingKeys for exluding these properties would work.
     Also keep in mind that inherited classes need specific coding keys to encode child's properties (so if A is a subclass of B, only the fields of B are in the exported dictionary)!
     */
    public func dictionary() throws -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw ExportError.encode(error: nil)
            }
            return jsonObject
        } catch {
            throw ExportError.encode(error: error)
        }
    }
}
