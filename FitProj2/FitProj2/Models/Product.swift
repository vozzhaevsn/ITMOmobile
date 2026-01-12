//
//  Product.swift
//  FitProj
//
//  Created by vozzh on 12.01.2026.
//

import Foundation

// MARK: - Product Model
/// Модель товара в магазине
struct Membership: Codable {
    let id: Int
    let title: String
    let price: Double
    let duration: String
    let description: String
}

