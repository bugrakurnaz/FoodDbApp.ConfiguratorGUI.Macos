//
//  AddCategoryView.swift
//  FoodDbApp.ConfiguratorGUI.Macos
//
//  Created by Muammer Buğra Kurnaz on 8.11.2025.
//

import SwiftUI

struct AddCategoryView: View {
    @State private var name: String = ""
    @State private var isLoading = false
    @State private var message: String?
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Add New Category")
                .font(.title)
                .bold()
            
            TextField("Category name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            
            Button(action:addCategory) {
                if isLoading {
                    ProgressView()
                }
                else {
                    Text("Add Category")
                }
            }
            .disabled(name.isEmpty || isLoading)
            if let message = message {
                Text(message)
                    .foregroundColor(.green)
                    .padding(.top)
            }
            
            Spacer()
        }
        .navigationTitle("Add Category")
        .padding()
    }
    
    private func addCategory() {
        isLoading = true;
        message = nil;
        let category = Category(id: nil, name: name)
        CategoryService.shared.addCategory(category) { result in
            DispatchQueue.main.async {
                isLoading = false;
                switch result {
                case .success(let created):
                    message = "Added: \(created.name)"
                    name = ""
                case .failure(let error):
                    message = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    AddCategoryView()
}
