//
//  URLSessionAsyncTest.swift
//  HomeProjectiOSSoftwareEngineerTests
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation
import XCTest

extension XCTestCase {
    func XCTAssertThrowsErrorAsync<T>(_ expression: @escaping () async throws -> T,
                                      _ message: @autoclosure () -> String = "",
                                      _ errorHandler: (_ error: Error) -> Void = { _ in }) async {
        do {
            _ = try await expression()
            XCTFail(message())
        } catch {
            errorHandler(error)
        }
    }
}
