//
//  RecipesRepositoryTests.swift
//  HomeProjectiOSSoftwareEngineerTests
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation
import XCTest
@testable import HomeProjectiOSSoftwareEngineer

final class RecipesRepositoryTests: XCTestCase {
    
    var mockHTTPClient: MockHTTPClient!
    var parser: JSONParser!
    var repository: RecipesRepository!
    
    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        parser = JSONParser()
    }
    
    override func tearDown() {
        mockHTTPClient = nil
        parser = nil
        repository = nil
        super.tearDown()
    }
    
    func testFetchRecipes_NormalData_ReturnsRecipes() async throws {
        let jsonString = """
        {
            "recipes": [
                {
                    "cuisine": "Italian",
                    "name": "Spaghetti Carbonara",
                    "photo_url_large": "https://example.com/large1.jpg",
                    "photo_url_small": "https://example.com/small1.jpg",
                    "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
                    "source_url": "https://example.com/recipe1.html",
                    "youtube_url": "https://www.youtube.com/watch?v=example1"
                },
                {
                    "cuisine": "Mexican",
                    "name": "Tacos",
                    "photo_url_large": "https://example.com/large2.jpg",
                    "photo_url_small": "https://example.com/small2.jpg",
                    "uuid": "a1b2c3d4-e5f6-7890-abcd-1234567890ab",
                    "source_url": "https://example.com/recipe2.html",
                    "youtube_url": "https://www.youtube.com/watch?v=example2"
                }
            ]
        }
        """
        mockHTTPClient.dataToReturn = jsonString.data(using: .utf8)
        repository = RecipesRepository(client: mockHTTPClient, parser: parser, source: .normal)
        
        let recipes = try await repository.fetchRecipes()
        
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes.first?.name, "Spaghetti Carbonara")
        XCTAssertEqual(recipes.last?.cuisine, "Mexican")
    }
    
    func testFetchRecipes_EmptyData_ReturnsEmpty() async throws {
        let jsonString = """
        {
            "recipes": []
        }
        """
        mockHTTPClient.dataToReturn = jsonString.data(using: .utf8)
        repository = RecipesRepository(client: mockHTTPClient, parser: parser, source: .empty)
        
        let recipes = try await repository.fetchRecipes()
        
        XCTAssertEqual(recipes.count, 0)
    }
    
    func testFetchRecipes_MalformedData_ThrowsError() async {
        let malformedJSON = """
        {
            "recipes": [
                {
                    "cuisine": "Italian",
                    "name": "Spaghetti Carbonara",
                    "uuid": "invalid-uuid"
                }
            ]
        }
        """
        mockHTTPClient.dataToReturn = malformedJSON.data(using: .utf8)
        repository = RecipesRepository(client: mockHTTPClient, parser: parser, source: .malformed)
        
        await XCTAssertThrowsErrorAsync({
            try await self.repository.fetchRecipes()
        }) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }

    
    func testFetchRecipes_HTTPClientThrowsError_ThrowsError() async {
        mockHTTPClient.errorToThrow = URLError(.notConnectedToInternet)
        repository = RecipesRepository(client: mockHTTPClient, parser: parser, source: .normal)
        
        await XCTAssertThrowsErrorAsync({
            try await self.repository.fetchRecipes()
        }) { error in
            XCTAssertTrue(error is URLError)
        }
    }
}
