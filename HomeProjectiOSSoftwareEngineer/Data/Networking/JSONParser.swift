//
//  JSONParser.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

struct JSONParser {
    func parse<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
