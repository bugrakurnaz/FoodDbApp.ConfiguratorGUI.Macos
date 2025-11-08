//
//  ContentView.swift
//  FoodDbApp.ConfiguratorGUI.Macos
//
//  Created by Muammer Buğra Kurnaz on 8.11.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedNavItem: MainNavigationItem? = .categories
    
    
    var body: some View {
        NavigationSplitView{
            List(selection: $selectedNavItem) {
                Label("Categories", systemImage: "tag.fill")
                    .tag(MainNavigationItem.categories)
                
                Label("Storage Locations", systemImage: "tag.fill")
                    .tag(MainNavigationItem.storageLocations)
                
                Label("Inventory Items", systemImage: "tag.fill")
                    .tag(MainNavigationItem.inventory)
            }
            .navigationTitle("Food Db App")
        } detail: {
            switch selectedNavItem {
            case .categories:
                CategoryManagementView()
            case .storageLocations:
                Text("Storage Location Management")
            case .inventory:
                Text("Inventory Management")
            default:
                Text("No Item Selected")
            }
        }
    }
}

#Preview {
    ContentView()
}
