//
//  RecipesListView.swift
//  HomeProjectiOSSoftwareEngineer
//
//  Created by Andrew Cheberyako on 12.02.2025.
//

import SwiftUI

struct RecipesListView: View {
    @StateObject var viewModel = RecipesViewModel()
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Recipes")
                .toolbar {
                    Menu("Data Source") {
                        Button("Normal") { viewModel.updateSource(to: .normal) }
                        Button("Malformed") { viewModel.updateSource(to: .malformed) }
                        Button("Empty") { viewModel.updateSource(to: .empty) }
                    }
                }
                .animation(.easeInOut, value: viewModel.viewState)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView("Loading...")
                .padding()
            
        case .empty:
            EmptyStateView()
                .padding()
            
        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.fetch() }
            }
            .padding()
            
        case .content(let recipes):
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(recipes) { recipe in
                        RecipeRowView(recipe: recipe)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.fetch(isRefresh: true)
            }
            .transition(.opacity)
        }
    }
}
