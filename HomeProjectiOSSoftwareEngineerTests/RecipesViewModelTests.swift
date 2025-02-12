//
//  RecipesViewModelTests.swift
//  HomeProjectiOSSoftwareEngineerTests
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import XCTest
@testable import HomeProjectiOSSoftwareEngineer

final class RecipesViewModelTests: XCTestCase {
    
    var viewModel: RecipesViewModel!
    var mockRepository: MockRecipesRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockRecipesRepository()
    }
    
    override func tearDown() {
        Task {
            await MainActor.run {
                viewModel = nil
            }
        }
        mockRepository = nil
        super.tearDown()
    }
    
    func testViewModel_ContentState() async {
        let recipes = [
            Recipe(
                id: UUID(),
                cuisine: "Italian",
                name: "Spaghetti Carbonara",
                photoURLLarge: URL(string: "https://example.com/large1.jpg")!,
                photoURLSmall: URL(string: "https://example.com/small1.jpg")!,
                sourceURL: URL(string: "https://example.com/recipe1.html")!,
                youtubeURL: URL(string: "https://www.youtube.com/watch?v=example1")!
            ),
            Recipe(
                id: UUID(),
                cuisine: "Mexican",
                name: "Tacos",
                photoURLLarge: URL(string: "https://example.com/large2.jpg")!,
                photoURLSmall: URL(string: "https://example.com/small2.jpg")!,
                sourceURL: URL(string: "https://example.com/recipe2.html")!,
                youtubeURL: URL(string: "https://www.youtube.com/watch?v=example2")!
            )
        ]
        mockRepository.recipesToReturn = recipes
        mockRepository.errorToThrow = nil
        
        await MainActor.run {
            viewModel = RecipesViewModel(repository: mockRepository)
        }
        await viewModel.fetch()
        
        switch await viewModel.viewState {
        case .content(let returnedRecipes):
            XCTAssertEqual(returnedRecipes.count, recipes.count)
            XCTAssertEqual(returnedRecipes.first?.name, "Spaghetti Carbonara")
        default:
            XCTFail("Expected content state")
        }
    }
    
    func testViewModel_EmptyState() async {
        mockRepository.recipesToReturn = []
        mockRepository.errorToThrow = nil
        
        await MainActor.run {
            viewModel = RecipesViewModel(repository: mockRepository)
        }
        await viewModel.fetch()
        
        switch await viewModel.viewState {
        case .empty:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected empty state")
        }
    }
    
    func testViewModel_ErrorState() async {
        mockRepository.recipesToReturn = []
        mockRepository.errorToThrow = URLError(.badServerResponse)

        await MainActor.run {
            viewModel = RecipesViewModel(repository: mockRepository)
        }
        await viewModel.fetch()
        
        switch await viewModel.viewState {
        case .error(let message):
            XCTAssertEqual(message, "Failed to load recipes.")
        default:
            XCTFail("Expected error state")
        }
    }
    
    func testViewModel_UpdateSource_SwitchToNormal() async {
        let recipes = [
            Recipe(
                id: UUID(),
                cuisine: "Italian",
                name: "Spaghetti Carbonara",
                photoURLLarge: URL(string: "https://example.com/large1.jpg")!,
                photoURLSmall: URL(string: "https://example.com/small1.jpg")!,
                sourceURL: URL(string: "https://example.com/recipe1.html")!,
                youtubeURL: URL(string: "https://www.youtube.com/watch?v=example1")!
            )
        ]
        mockRepository.recipesToReturn = recipes
        mockRepository.errorToThrow = nil

        await MainActor.run {
            viewModel = RecipesViewModel(repository: mockRepository)
        }
        await viewModel.updateSource(to: .normal)

        switch await viewModel.viewState {
        case .content(let returnedRecipes):
            XCTAssertEqual(returnedRecipes.count, 1)
            XCTAssertEqual(returnedRecipes.first?.name, "Spaghetti Carbonara")
        default:
            XCTFail("Expected content state")
        }
    }
}
