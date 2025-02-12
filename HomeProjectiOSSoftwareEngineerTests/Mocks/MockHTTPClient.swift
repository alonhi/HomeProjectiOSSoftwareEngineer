//
//  MockHTTPClient.swift
//  HomeProjectiOSSoftwareEngineerTests
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation
@testable import HomeProjectiOSSoftwareEngineer

class MockHTTPClient: HTTPClientProtocol {
    var dataToReturn: Data?
    var errorToThrow: Error?
    
    func fetchData(from url: URL) async throws -> Data {
        if let error = errorToThrow {
            throw error
        }
        guard let data = dataToReturn else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
