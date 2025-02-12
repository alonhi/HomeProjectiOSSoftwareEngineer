//
//  HTTPClientProtocol.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

protocol HTTPClientProtocol {
    func fetchData(from url: URL) async throws -> Data
}
