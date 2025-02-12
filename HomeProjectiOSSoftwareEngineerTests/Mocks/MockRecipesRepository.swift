//
//  MockRecipesRepository.swift
//  HomeProjectiOSSoftwareEngineerTests
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

@testable import HomeProjectiOSSoftwareEngineer

class MockRecipesRepository: RecipesRepositoryProtocol {
    var recipesToReturn: [Recipe] = []
    var errorToThrow: Error?
    
    func fetchRecipes() async throws -> [Recipe] {
        if let error = errorToThrow {
            throw error
        }
        return recipesToReturn
    }
}
