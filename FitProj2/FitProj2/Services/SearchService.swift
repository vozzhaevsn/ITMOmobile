//
//  SearchService.swift
//  Created by vozzhaevsn on 07.01.2026.
//

import Foundation

class SearchService {

    // Генерация n-грамм из текста
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

    /// Поиск абонементов по n-gram
    func searchMemberships(_ items: [Membership], query: String) -> [Membership] {
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

        var result: [(Membership, Int)] = []

        for membership in items {
            // индексируем заголовок, длительность и описание
            let combinedText = [
                membership.title,
                membership.duration,
                membership.description
            ].joined(separator: " ")

            let textGrams = generateNGrams(from: combinedText, n: n)

            var matches = 0
            for gram in queryGrams {
                if textGrams.contains(gram) {
                    matches += 1
                }
            }

            // порог можно подвигать; 1–2 совпадения для фитнес-абонементов обычно хватает
            if matches >= 1 {
                result.append((membership, matches))
            }
        }

        // сортируем по числу совпадений (релевантности)
        result.sort { $0.1 > $1.1 }

        return result.map { $0.0 }
    }
}
