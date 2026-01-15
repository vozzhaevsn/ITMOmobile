//
//  CarDataBaseService'.swift
//  CarProj2
//
//  Created by vozzh on 14.01.2026.
//

import Foundation

enum CarDataError: Error {
    case fileNotFound
    case readFailed
    case decodeFailed
}

/// Сервис загрузки каталога автомобилей из локального JSON-файла
final class CarDatabaseService {

    static let shared = CarDatabaseService()
    private init() {}

    func loadCars(completion: @escaping (Result<[Car], CarDataError>) -> Void) {
        // Ищем файл Cars.json в бандле приложения
        guard let url = Bundle.main.url(forResource: "Cars", withExtension: "json") else {
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
            let items = try decoder.decode([Car].self, from: data)
            completion(.success(items))
        } catch {
            print("JSON decode error:", error)
            completion(.failure(.decodeFailed))
        }
    }
}

