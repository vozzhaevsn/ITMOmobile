//
//  Product.swift
//  FitProj
//
//  Created by vozzh on 12.01.2026.
import Foundation

// MARK: - Cart Manager (Singleton)
/// Менеджер корзины - управляет абонементами в корзине пользователя
class CartManager {
    static let shared = CartManager()
    private init() {}

    // MARK: - Properties
    /// Список выбранных абонементов
    var cartItems: [Membership] = []

    // MARK: - Public Methods

    /// Добавить абонемент в корзину
    func addToCart(_ item: Membership) {
        cartItems.append(item)
    }

    /// Удалить абонемент из корзины по индексу
    func removeFromCart(at index: Int) {
        guard cartItems.indices.contains(index) else { return }
        cartItems.remove(at: index)
    }

    /// Общая стоимость всех абонементов в корзине
    func getTotalPrice() -> Double {
        return cartItems.reduce(0) { $0 + $1.price }
    }

    /// Очистить корзину
    func clearCart() {
        cartItems.removeAll()
    }

    /// Количество абонементов в корзине
    func getItemsCount() -> Int {
        return cartItems.count
    }
    var totalPrice: Double {
            getTotalPrice()
    }
}
