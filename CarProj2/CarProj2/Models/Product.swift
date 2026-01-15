//
//  Product.swift
//  CarProj2
//
//  Created by vozzh on 14.01.2026.
//

import Foundation

struct Car: Codable {
    let id: Int
    let brand: String
    let model: String
    let year: Int
    let price: Double
    let description: String
}
