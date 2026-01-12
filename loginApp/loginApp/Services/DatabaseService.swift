//
//  DatabaseService.swift
//  loginApp
//
//  Created by vozzh on 11.01.2026.
//

import Foundation

enum DataError: Error {
    case fileNotFound
    case readFailed
    case decodeFailed
}

final class DatabaseService {
    static let shared = DatabaseService()
    private init() {}

    func loadProducts(completion: @escaping (Result<[GoodsModel], DataError>) -> Void) {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            completion(.failure(.fileNotFound))
            return
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            completion(.failure(.readFailed))
            return
        }

        do {
            let decoder = JSONDecoder()
            let items = try decoder.decode([GoodsModel].self, from: data)
            completion(.success(items))
        } catch {
            print("JSON decode error:", error)
            completion(.failure(.decodeFailed))
        }
    }
}
