//
//  ImageLoader.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

actor ImageLoader {
    private let cache: ImageCache
    
    init(cache: ImageCache = DiskImageCache()) {
        self.cache = cache
    }
    
    func loadImage(from url: URL) async throws -> Data {
        let cacheKey = cacheKeyForURL(url)
        
        if let cachedData = await cache.image(forKey: cacheKey) {
            return cachedData
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        await cache.storeImage(data: data, forKey: cacheKey)
        
        return data
    }
    
    private func cacheKeyForURL(_ url: URL) -> String {
        let allowedCharacters = CharacterSet.alphanumerics
        let filtered = url.absoluteString.unicodeScalars.filter { allowedCharacters.contains($0) }
        let key = String(filtered)
        
        return key.isEmpty ? UUID().uuidString : key
    }
}
