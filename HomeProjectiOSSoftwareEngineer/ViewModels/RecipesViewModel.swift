//
//  RecipesViewModel.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

enum RecipesViewState: Equatable {
    case loading
    case empty
    case error(String)
    case content([Recipe])
}

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published var viewState: RecipesViewState = .loading
    
    private let client: HTTPClientProtocol
    private let parser: JSONParser
    private var repository: RecipesRepositoryProtocol
    
    init(client: HTTPClientProtocol = HTTPClient(),
         parser: JSONParser = JSONParser(),
         sourceType: RecipesSourceType = .normal,
         repository: RecipesRepositoryProtocol? = nil) {
        self.client = client
        self.parser = parser
        self.repository = repository ?? RecipesRepository(client: client, parser: parser, source: sourceType)
        Task {
            await fetch()
        }
    }
    
    func updateSource(to newSource: RecipesSourceType) {
        repository = RecipesRepository(client: client, parser: parser, source: newSource)
        Task {
            await fetch()
        }
    }
    
    func fetch(isRefresh: Bool = false) async {
        if !isRefresh {
            viewState = .loading
        }
        
        do {
            let fetched = try await repository.fetchRecipes()
            if fetched.isEmpty {
                viewState = .empty
            } else {
                viewState = .content(fetched)
            }
        } catch {
            viewState = .error("Failed to load recipes.")
        }
    }
}
