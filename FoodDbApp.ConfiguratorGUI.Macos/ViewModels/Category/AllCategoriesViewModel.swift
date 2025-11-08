//
//  AllCategoriesViewModel.swift
//  FoodDbApp.ConfiguratorGUI.Macos
//
//  Created by Muammer Buğra Kurnaz on 8.11.2025.
//

import Foundation
import Combine

// ObservableObject is a class protocol that SwiftUI can subscribe to for changes.
class AllCategoriesViewModel: ObservableObject {
    
    // @Published is like a super-powered property notification.
    // Any view using this ViewModel will automatically update when these properties change.
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // The main function to trigger the data fetch.
    func fetchCategories() {
        isLoading = true
        errorMessage = nil
        
        CategoryService.shared.getAllCategories { [weak self] result in
            // [weak self] is important to prevent memory leaks
            self?.isLoading = false
            switch result {
            case .success(let fetchedCategories):
                self?.categories = fetchedCategories
            case .failure(let error):
                self?.errorMessage = "Failed to load categories: \(error.localizedDescription)"
            }
        }
    }
}
