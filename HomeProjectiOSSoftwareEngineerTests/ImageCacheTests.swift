//
//  ImageCacheTests.swift
//  HomeProjectiOSSoftwareEngineerTests
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import XCTest
@testable import HomeProjectiOSSoftwareEngineer

final class ImageCacheTests: XCTestCase {
    
    var imageCache: DiskImageCache!
    var tempDirectory: URL!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Create a temporary directory for testing
        tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true, attributes: nil)
        
        // Initialize DiskImageCache with the temporary directory
        imageCache = DiskImageCache(cacheDirectory: tempDirectory)
    }
    
    override func tearDown() async throws {
        // Clean up the temporary directory after tests
        try? FileManager.default.removeItem(at: tempDirectory)
        imageCache = nil
        tempDirectory = nil
        try await super.tearDown()
    }
    
    func testStoreAndRetrieveImage() async throws {
        // Arrange
        let key = "testImage"
        let data = "TestImageData".data(using: .utf8)!
        
        // Act
        await imageCache.storeImage(data: data, forKey: key)
        let retrievedData = await imageCache.image(forKey: key)
        
        // Assert
        XCTAssertEqual(retrievedData, data)
    }
    
    func testRetrieveNonExistentImage_ReturnsNil() async throws {
        // Arrange
        let key = "nonExistentImage"
        
        // Act
        let retrievedData = await imageCache.image(forKey: key)
        
        // Assert
        XCTAssertNil(retrievedData)
    }
    
    func testOverwriteExistingImage() async throws {
        // Arrange
        let key = "overwriteImage"
        let initialData = "InitialData".data(using: .utf8)!
        let newData = "NewData".data(using: .utf8)!
        
        // Act
        await imageCache.storeImage(data: initialData, forKey: key)
        var retrievedData = await imageCache.image(forKey: key)
        XCTAssertEqual(retrievedData, initialData)
        
        await imageCache.storeImage(data: newData, forKey: key)
        retrievedData = await imageCache.image(forKey: key)
        
        // Assert
        XCTAssertEqual(retrievedData, newData)
    }
}
