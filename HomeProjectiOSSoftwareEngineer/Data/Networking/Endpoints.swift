//
//  Endpoints.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

enum Endpoints {
    static private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    
    static var allRecipes: URL {
        return URL(string: "\(baseURL)/recipes.json")!
    }
    
    static var malformedRecipes: URL {
        return URL(string: "\(baseURL)/recipes-malformed.json")!
    }
    
    static var emptyRecipes: URL {
        return URL(string: "\(baseURL)/recipes-empty.json")!
    }
}
