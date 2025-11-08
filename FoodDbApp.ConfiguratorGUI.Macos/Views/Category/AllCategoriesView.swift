//
//  AllCategoriesView.swift
//  FoodDbApp.ConfiguratorGUI.Macos
//
//  Created by Muammer Buğra Kurnaz on 8.11.2025.
//

import SwiftUI

struct AllCategoriesView: View {
    // @StateObject tells SwiftUI to create and manage the lifecycle of our ViewModel.
    // The view now "owns" this ViewModel.
    @StateObject private var viewModel = AllCategoriesViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            // We'll show different views depending on the state from our ViewModel
            if viewModel.isLoading {
                ProgressView("Loading Categories...")
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                    Button("Retry") {
                        viewModel.fetchCategories()
                    }
                }
            } else if viewModel.categories.isEmpty {
                Text("No categories found. Add one in the 'Add New' tab.")
                    .font(.title)
                    .foregroundColor(.secondary)
            } else {
                
                Text("All Categories")
                    .font(.title)
                    .bold()
                // This is the SwiftUI equivalent of a ListBox or ItemsControl
                List(viewModel.categories) { category in
                    // This creates a row for each category in the array
                    HStack {
                        Text(category.name)
                        Spacer()
                        // You can add Edit/Delete buttons here later
                    }
                }
            }
        }
        // This modifier tells SwiftUI to run a function when the view first appears.
        .onAppear {
            viewModel.fetchCategories()
        }
        .navigationTitle("All Categories") // Sets the title for this view area
        .padding()
    }
}

#Preview {
    AllCategoriesView()
        .frame(width: 400, height: 300)
}
