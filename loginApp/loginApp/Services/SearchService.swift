//
//  SearchService.swift
//  loginApp
//Создаем сервис для генерации триграмм,похожесть ввода слова и товара в каталоге и поиск товара
//  Created by vozzhaevsn on 07.01.2026.
//

import Foundation


class SearchService {
    func generateNGrams(from text: String, n: Int) -> [String] {
        let lower = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        var result: [String] = []

        if lower.count < n {
            return result
        }

        let chars = Array(lower)
        for i in 0...(chars.count - n) {
            let gram = String(chars[i..<(i + n)])
            result.append(gram)
        }

        return result
    }

    // Делаем поиск
    func searchProducts(_ products: [GoodsModel], query: String) -> [GoodsModel] {
        let q = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        if q.isEmpty {
            return products
        }

        let n = q.count <= 4 ? 2 : 3
        let queryGrams = generateNGrams(from: q, n: n)
        if queryGrams.isEmpty {
            return []
        }

        var result: [(GoodsModel, Int)] = []

        for product in products {
            let titleGrams = generateNGrams(from: product.title, n: n)
            let descGrams  = generateNGrams(from: product.description, n: n)

            var matches = 0
            for gram in queryGrams {
                if titleGrams.contains(gram) || descGrams.contains(gram) {
                    matches += 1
                }
            }

            if matches >= 2 {
                result.append((product, matches))
            }
        }

        // Делаем сортировку
        result.sort { $0.1 > $1.1 }

        return result.map { $0.0 }
    }
}
