//
//  EditCategoryViewModel.swift
//  FoodDbApp.ConfiguratorGUI.Macos
//
//  Created by Muammer Buğra Kurnaz on 8.11.2025.
//

//
//  EditCategoryViewModel.swift
//  FoodDbApp.ConfiguratorGUI.Macos
//
//  Created by Muammer Buğra Kurnaz on 8.11.2025.
//

import Foundation
import Combine

class EditCategoryViewModel: ObservableObject {
    
    // Published properties to drive the UI
    @Published var allCategories: [Category] = []
    @Published var selectedCategoryId: UUID? {
        didSet {
            // When a category is selected, update the text field
            if let selectedCategory = allCategories.first(where: { $0.id == selectedCategoryId }) {
                categoryName = selectedCategory.name
            }
        }
    }
    @Published var categoryName: String = ""
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess = false;
    @Published var didFinishSaving = false
    
    // Fetch all categories to populate the picker
    func fetchAllCategories() {
        isLoading = true
        errorMessage = nil
        
        CategoryService.shared.getAllCategories { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let categories):
                self?.allCategories = categories
                // Optionally, pre-select the first category
                if let firstCategory = categories.first {
                    self?.selectedCategoryId = firstCategory.id
                }
            case .failure(let error):
                self?.errorMessage = "Failed to load categories: \(error.localizedDescription)"
            }
        }
    }
    
    // Save the changes to the selected category
    func saveCategory() {
        isSuccess = false;
        guard let selectedId = selectedCategoryId else {
            errorMessage = "No category selected."
            return
        }
        
        guard !categoryName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Category name cannot be empty."
            return
        }
        
        var categoryToUpdate = allCategories.first { $0.id == selectedId }!
        categoryToUpdate.name = categoryName

        isSaving = true
        errorMessage = nil
        
        CategoryService.shared.updateCategory(categoryToUpdate) { [weak self] result in
            self?.isSaving = false
            switch result {
            case .success:
                self?.didFinishSaving = true
                self?.isSuccess = true
            case .failure(let error):
                self?.errorMessage = "Failed to save changes: \(error.localizedDescription)"
            }
        }
    }
}
