//
//  RecipesRepository.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

struct RecipesRepository: RecipesRepositoryProtocol {
    private let client: HTTPClientProtocol
    private let parser: JSONParser
    private let source: RecipesSourceType
    
    init(client: HTTPClientProtocol = HTTPClient(),
         parser: JSONParser = JSONParser(),
         source: RecipesSourceType = .normal) {
        self.client = client
        self.parser = parser
        self.source = source
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        let url: URL
        switch source {
        case .normal:
            url = Endpoints.allRecipes
        case .malformed:
            url = Endpoints.malformedRecipes
        case .empty:
            url = Endpoints.emptyRecipes
        }
        
        let data = try await client.fetchData(from: url)
        let response: RecipesResponse = try parser.parse(data)
        
        return response.recipes
    }
}
