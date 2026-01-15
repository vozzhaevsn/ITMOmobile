//
//  User.swift
//  CarProj2
//
//  Created by vozzh on 14.01.2026.
//
//  Created by vozzh on 12.01.2026.
//

import Foundation

// MARK: - User Model
/// Модель пользователя приложения
struct User {
    let id: String
    let login: String
    let password: String
}

// MARK: - Local Storage
extension User:Codable {

    private static let storageKey = "currentUser"

    func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self) {
            UserDefaults.standard.set(data, forKey: User.storageKey)
        }
    }

    static func load() -> User? {
        guard let data = UserDefaults.standard.data(forKey: User.storageKey) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(User.self, from: data)
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: User.storageKey)
    }
}

