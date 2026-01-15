//
//  CartManager.swift
//  CarProj2
//
//  Created by vozzh on 14.01.2026.
//
import Foundation

// MARK: - Cart Manager (Singleton)
/// Менеджер корзины - управляет выбранными автомобилями
class CartManager {
    
    static let shared = CartManager()
    private init() {}
    
    // MARK: - Properties
    
    /// Список выбранных автомобилей
    var cartItems: [Car] = []
    
    // MARK: - Public Methods
    
    /// Добавить автомобиль в корзину
    func addToCart(_ item: Car) {
        cartItems.append(item)
    }
    
    /// Удалить автомобиль из корзины по индексу
    func removeFromCart(at index: Int) {
        guard cartItems.indices.contains(index) else { return }
        cartItems.remove(at: index)
    }
    
    /// Общая стоимость всех автомобилей в корзине
    func getTotalPrice() -> Double {
        return cartItems.reduce(0) { $0 + $1.price }
    }
    
    /// Очистить корзину
    func clearCart() {
        cartItems.removeAll()
    }
    
    /// Количество автомобилей в корзине
    func getItemsCount() -> Int {
        return cartItems.count
    }
    
    /// Текущая суммарная стоимость
    var totalPrice: Double {
        getTotalPrice()
    }
}

