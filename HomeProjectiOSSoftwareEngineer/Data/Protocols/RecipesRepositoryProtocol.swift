//
//  RecipesRepositoryProtocol.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

protocol RecipesRepositoryProtocol {
    func fetchRecipes() async throws -> [Recipe]
}
