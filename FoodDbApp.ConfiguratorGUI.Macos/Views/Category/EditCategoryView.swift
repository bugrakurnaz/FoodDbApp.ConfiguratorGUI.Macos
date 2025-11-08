//
//  EditCategoryView.swift
//  FoodDbApp.ConfiguratorGUI.Macos
//
//  Created by Muammer Buğra Kurnaz on 8.11.2025.
//

import SwiftUI

struct EditCategoryView: View {
    
    @StateObject private var viewModel = EditCategoryViewModel();
    private var displayedId: String {
        viewModel.selectedCategoryId?.uuidString ?? "Not Selected"
    }
    
    // Environment object to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("Edit a Category")
                .font(.title)
                .bold()
            
            // Show a progress indicator while loading categories for the picker
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                
                // PICKER (COMBOBOX)
                Picker("Category:", selection: $viewModel.selectedCategoryId) {
                    ForEach(viewModel.allCategories) { category in
                        Text(category.name).tag(category.id as UUID?)
                    }
                }
                
                HStack {
                    Text("Selected Category ID: ")
                    
                    Text(displayedId)
                }
                
                Divider()
                
                // TEXTBOX FOR NEW VALUE
                VStack(alignment: .leading) {
                    Text("New Name:")
                        .font(.headline)

                    TextField("Enter new category name", text: $viewModel.categoryName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer()
                
                // Display error messages
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                if viewModel.isSuccess {
                    Text("Category updated successfully.")
                        .foregroundColor(.green)
                        .font(.caption)
                }

                // BUTTON
                HStack {
                    
                    Spacer()
                    
                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        Button("Save Changes") {
                            viewModel.saveCategory()
                        }
                        .keyboardShortcut(.defaultAction)
                        // Disable the button if no category is selected or name is empty
                        .disabled(viewModel.selectedCategoryId == nil || viewModel.categoryName.isEmpty)
                    }
                }
            }
        }
        .padding()
        .frame(minWidth: 350, minHeight: 250)
        // Fetch categories when the view appears
        .onAppear {
            viewModel.fetchAllCategories()
        }
        // Dismiss the view automatically after a successful save
        .onChange(of: viewModel.didFinishSaving) { _, _ in
            viewModel.fetchAllCategories()
        }
    }
}

#Preview {
    EditCategoryView()
    .frame(width: 400, height: 300)
}
