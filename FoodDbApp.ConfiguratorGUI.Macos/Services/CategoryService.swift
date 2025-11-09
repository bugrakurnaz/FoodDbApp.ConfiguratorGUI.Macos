//
//  CategoryService.swift
//  FoodDbApp.ConfiguratorGUI.Macos
//
//  Created by Muammer Buğra Kurnaz on 8.11.2025.
//

import Foundation

class CategoryService {
    static let shared = CategoryService()
    private let baseUrl = URL(string: "http://localhost:5000/api/")
    
    func addCategory(_ category: Category, completion: @escaping (Result<Category, Error>) -> Void) {
        guard let url = URL(string: "categories", relativeTo: baseUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(category)
        }
        catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                        do {
                            // It is now safe to decode the Main Actor-isolated Category
                            let created = try JSONDecoder().decode(Category.self, from: data)
                            completion(.success(created))
                        } catch {
                            // Decoding failed, pass the error along
                            completion(.failure(error))
                        }
                    }
        }.resume( )
    }
    
    func deleteCategory(_ category: Category, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let categoryId = category.id?.uuidString else { return }
        guard let url = URL(string: "categories/\(categoryId)", relativeTo: baseUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            DispatchQueue.main.async {
                completion(.success(()))
            }
            
        }.resume()
    }
    
    func updateCategory(_ category: Category, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let categoryId = category.id else {
            let missingIdError = NSError(domain: "AppError", code: 100, userInfo: [NSLocalizedDescriptionKey: "Category ID is missing for update."])
            completion(.failure(missingIdError))
            return
        }
        
        guard let url = URL(string: "categories/\(categoryId.uuidString)", relativeTo: baseUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(category)
        }
        catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            DispatchQueue.main.async {
                completion(.success(()))
            }
        }.resume()
    }
    
    func getAllCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
            guard let url = URL(string: "categories", relativeTo: baseUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }

                guard let data = data else {
                    let noDataError = NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    DispatchQueue.main.async {
                        completion(.failure(noDataError))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        let categories = try JSONDecoder().decode([Category].self, from: data)
                        completion(.success(categories))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
}
