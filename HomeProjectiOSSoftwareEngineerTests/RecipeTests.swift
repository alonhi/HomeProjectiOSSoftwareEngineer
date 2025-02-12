//
//  RecipeTests.swift
//  HomeProjectiOSSoftwareEngineerTests
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import XCTest
@testable import HomeProjectiOSSoftwareEngineer

final class RecipeTests: XCTestCase {
    
    func testRecipeInitializer() {
        let id = UUID()
        let cuisine = "Italian"
        let name = "Spaghetti Carbonara"
        let photoURLLarge = URL(string: "https://example.com/large1.jpg")
        let photoURLSmall = URL(string: "https://example.com/small1.jpg")
        let sourceURL = URL(string: "https://example.com/recipe1.html")
        let youtubeURL = URL(string: "https://www.youtube.com/watch?v=example1")
        
        let recipe = Recipe(id: id,
                            cuisine: cuisine,
                            name: name,
                            photoURLLarge: photoURLLarge,
                            photoURLSmall: photoURLSmall,
                            sourceURL: sourceURL,
                            youtubeURL: youtubeURL)
        
        XCTAssertEqual(recipe.id, id)
        XCTAssertEqual(recipe.cuisine, cuisine)
        XCTAssertEqual(recipe.name, name)
        XCTAssertEqual(recipe.photoURLLarge, photoURLLarge)
        XCTAssertEqual(recipe.photoURLSmall, photoURLSmall)
        XCTAssertEqual(recipe.sourceURL, sourceURL)
        XCTAssertEqual(recipe.youtubeURL, youtubeURL)
    }
    
    func testRecipeDecoding_ValidJSON() throws {
        let jsonString = """
        {
            "cuisine": "Mexican",
            "name": "Tacos",
            "photo_url_large": "https://example.com/large2.jpg",
            "photo_url_small": "https://example.com/small2.jpg",
            "uuid": "a1b2c3d4-e5f6-7890-abcd-1234567890ab",
            "source_url": "https://example.com/recipe2.html",
            "youtube_url": "https://www.youtube.com/watch?v=example2"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let recipe = try decoder.decode(Recipe.self, from: jsonData)
        
        XCTAssertEqual(recipe.cuisine, "Mexican")
        XCTAssertEqual(recipe.name, "Tacos")
        XCTAssertEqual(recipe.photoURLLarge, URL(string: "https://example.com/large2.jpg"))
        XCTAssertEqual(recipe.photoURLSmall, URL(string: "https://example.com/small2.jpg"))
        XCTAssertEqual(recipe.id, UUID(uuidString: "a1b2c3d4-e5f6-7890-abcd-1234567890ab"))
        XCTAssertEqual(recipe.sourceURL, URL(string: "https://example.com/recipe2.html"))
        XCTAssertEqual(recipe.youtubeURL, URL(string: "https://www.youtube.com/watch?v=example2"))
    }
    
    func testRecipeDecoding_InvalidUUID_ThrowsError() {
        let jsonString = """
        {
            "cuisine": "French",
            "name": "Croissant",
            "photo_url_large": "https://example.com/large3.jpg",
            "photo_url_small": "https://example.com/small3.jpg",
            "uuid": "invalid-uuid",
            "source_url": "https://example.com/recipe3.html",
            "youtube_url": "https://www.youtube.com/watch?v=example3"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        XCTAssertThrowsError(try decoder.decode(Recipe.self, from: jsonData)) { error in
            guard case DecodingError.dataCorrupted(let context) = error else {
                return XCTFail("Expected DecodingError.dataCorrupted")
            }
            XCTAssertEqual(context.debugDescription, "Invalid UUID")
        }
    }
}
