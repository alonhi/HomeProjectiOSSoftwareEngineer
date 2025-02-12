//
//  RecipesSourceType.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

enum RecipesSourceType: String, CaseIterable, Identifiable, Hashable {
    case normal
    case malformed
    case empty
    
    var id: Self { self }
}
