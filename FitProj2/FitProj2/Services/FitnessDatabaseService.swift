//
//  FitnessDatabaseService.swift
//  loginApp
//
//  Created by vozzh on 11.01.2026.
//
import Foundation

enum FitnessDataError: Error {
    case fileNotFound
    case readFailed
    case decodeFailed
}

final class FitnessDatabaseService {
    static let shared = FitnessDatabaseService()
    private init() {}

    func loadMemberships(completion: @escaping (Result<[Membership], FitnessDataError>) -> Void) {
        guard let url = Bundle.main.url(forResource: "Memberships", withExtension: "json") else {
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
            let items = try decoder.decode([Membership].self, from: data)
            completion(.success(items))
        } catch {
            print("JSON decode error:", error)
            completion(.failure(.decodeFailed))
        }
    }
}
