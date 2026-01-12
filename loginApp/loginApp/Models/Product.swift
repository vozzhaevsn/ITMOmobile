//
//  Product.swift
//  loginApp
//
//  Created by Дмитрий Васильев on 19.12.2025.
//

import Foundation

// MARK: - Product Model
/// Модель товара в магазине
struct GoodsModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let images: [String]?
    var quantity: Int = 1

   var image: String {
           "bag"
       }
       
       enum CodingKeys: String, CodingKey {
           case id, title, price, description, images
       }
   }
