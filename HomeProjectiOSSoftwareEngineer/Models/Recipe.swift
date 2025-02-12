//
//  Recipe.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import Foundation

struct Recipe: Identifiable, Decodable, Equatable {
    let id: UUID
    let cuisine: String
    let name: String
    let photoURLLarge: URL?
    let photoURLSmall: URL?
    let sourceURL: URL?
    let youtubeURL: URL?

    private enum CodingKeys: String, CodingKey {
        case uuid
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let uuidString = try container.decode(String.self, forKey: .uuid)
        guard let uuid = UUID(uuidString: uuidString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .uuid,
                in: container,
                debugDescription: "Invalid UUID"
            )
        }
        self.id = uuid
        
        self.cuisine = try container.decode(String.self, forKey: .cuisine)
        self.name = try container.decode(String.self, forKey: .name)
        self.photoURLLarge = try container.decodeIfPresent(URL.self, forKey: .photoURLLarge)
        self.photoURLSmall = try container.decodeIfPresent(URL.self, forKey: .photoURLSmall)
        self.sourceURL = try container.decodeIfPresent(URL.self, forKey: .sourceURL)
        self.youtubeURL = try container.decodeIfPresent(URL.self, forKey: .youtubeURL)
    }
    
    init(
        id: UUID,
        cuisine: String,
        name: String,
        photoURLLarge: URL? = nil,
        photoURLSmall: URL? = nil,
        sourceURL: URL? = nil,
        youtubeURL: URL? = nil
    ) {
        self.id = id
        self.cuisine = cuisine
        self.name = name
        self.photoURLLarge = photoURLLarge
        self.photoURLSmall = photoURLSmall
        self.sourceURL = sourceURL
        self.youtubeURL = youtubeURL
    }
}
