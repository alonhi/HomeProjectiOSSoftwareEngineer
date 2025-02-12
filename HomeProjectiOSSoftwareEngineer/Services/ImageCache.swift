//
//  ImageCache.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

protocol ImageCache {
    func image(forKey key: String) async -> Data?
    func storeImage(data: Data, forKey key: String) async
}
