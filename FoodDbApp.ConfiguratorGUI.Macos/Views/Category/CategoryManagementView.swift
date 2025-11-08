//
//  CategoryManagementView.swift
//  FoodDbApp.ConfiguratorGUI.Macos
//
//  Created by Muammer Buğra Kurnaz on 8.11.2025.
//

import SwiftUI

struct CategoryManagementView: View {
    var body: some View {
            // This TabView will provide the top-level controls for the Category section.
            TabView {
                AllCategoriesView()
                    .tabItem {
                        Label("View All", systemImage: "list.bullet")
                    }

                AddCategoryView()
                    .tabItem {
                        Label("Add New", systemImage: "plus")
                    }
                
                EditCategoryView()
                    .tabItem {
                        Label("Edit", systemImage: "pencil")
                    }
            }
            .tabViewStyle(.automatic)
        }
}


#Preview {
    CategoryManagementView()
}
