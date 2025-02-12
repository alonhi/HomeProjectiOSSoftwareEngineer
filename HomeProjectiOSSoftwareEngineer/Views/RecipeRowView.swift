//
//  RecipeRowView.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    @State private var imageData: Data?
    private let loader = ImageLoader()
    
    var body: some View {
        HStack {
            ZStack {
                
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .task {
            if let url = recipe.photoURLSmall {
                do {
                    self.imageData = try await loader.loadImage(from: url)
                } catch {
                    self.imageData = UIImage(systemName: "photo")?.pngData()
                }
            }
        }
    }
}
