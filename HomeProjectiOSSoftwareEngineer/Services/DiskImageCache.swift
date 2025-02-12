//
//  DiskImageCache.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

actor DiskImageCache: ImageCache {
    private let cacheDirectory: URL
    
    init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let cacheDir = paths.first else {
            fatalError("Unable to access caches directory")
        }
        
        self.cacheDirectory = cacheDir
    }
    
    init(cacheDirectory: URL) {
        self.cacheDirectory = cacheDirectory
    }
    
    func image(forKey key: String) async -> Data? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        return try? Data(contentsOf: fileURL)
    }
    
    func storeImage(data: Data, forKey key: String) async {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to write image data to disk: \(error)")
        }
    }
}
