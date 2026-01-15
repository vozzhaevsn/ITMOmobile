//
//  SearchService.swift
//  CarProj2
//
//  Created by vozzh on 14.01.2026.
//

import Foundation

class SearchService {

    // Генерация n‑грамм из текста
    func generateNGrams(from text: String, n: Int) -> [String] {
        let lower = text
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard lower.count >= n else { return [] }

        let chars = Array(lower)
        var result: [String] = []

        for i in 0...(chars.count - n) {
            let gram = String(chars[i..<(i + n)])
            result.append(gram)
        }

        return result
    }

    /// Поиск автомобилей по n‑граммам
    func searchCars(_ items: [Car], query: String) -> [Car] {
        let q = query
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if q.isEmpty {
            return items
        }

        // для коротких запросов используем биграммы, для длинных — триграммы
        let n = q.count <= 4 ? 2 : 3
        let queryGrams = generateNGrams(from: q, n: n)
        if queryGrams.isEmpty {
            return []
        }

        var result: [(Car, Int)] = []

        for car in items {
            // индексируем марку, модель, год и описание
            let combinedText = [
                car.brand,
                car.model,
                String(car.year),
                car.description
            ].joined(separator: " ")

            let textGrams = generateNGrams(from: combinedText, n: n)

            var matches = 0
            for gram in queryGrams {
                if textGrams.contains(gram) {
                    matches += 1
                }
            }

            // порог можно регулировать; одного совпадения достаточно
            if matches >= 1 {
                result.append((car, matches))
            }
        }

        // сортируем по числу совпадений (релевантности)
        result.sort { $0.1 > $1.1 }

        return result.map { $0.0 }
    }
}

