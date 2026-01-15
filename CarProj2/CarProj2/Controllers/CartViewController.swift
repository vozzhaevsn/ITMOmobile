//
//  CartViewController.swift
//  CarProj2
//
//  Created by vozzh on 14.01.2026.
//

import UIKit

// MARK: - Cart View Controller
/// Контроллер экрана корзины
class CartViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var totalPriceLabel: UILabel?
    @IBOutlet weak var checkoutButton: UIButton?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    // MARK: - Setup
    private func setupUI() {
        title = "Корзина"

        if tableView != nil {
            setupTableView()
        } else {
            setupUIProgrammatically()
        }
    }

    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "CartCell")
        tableView?.rowHeight = 80
    }

    private func setupUIProgrammatically() {
        view.backgroundColor = .systemBackground

        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CartCell")
        table.rowHeight = 80
        view.addSubview(table)
        tableView = table

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        view.addSubview(label)
        totalPriceLabel = label

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Оформить заказ", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        view.addSubview(button)
        checkoutButton = button

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -16),

            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: 40),

            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - UI Update
    private func updateUI() {
        tableView?.reloadData()
        let totalPrice = CartManager.shared.getTotalPrice()
        totalPriceLabel?.text = String(format: "Итого: %.2f ₽", totalPrice)
        checkoutButton?.isEnabled = !CartManager.shared.cartItems.isEmpty
    }

    // MARK: - IBActions
    @objc @IBAction func checkoutButtonTapped() {
        guard !CartManager.shared.cartItems.isEmpty else { return }

        let alert = UIAlertController(
            title: "Оформление заказа",
            message: String(format: "Подтвердить заказ на сумму %.2f ₽?", CartManager.shared.getTotalPrice()),
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Подтвердить", style: .default) { [weak self] _ in
            self?.completeCheckout()
        })

        present(alert, animated: true)
    }

    // MARK: - Private Methods
    private func completeCheckout() {
        CartManager.shared.clearCart()
        updateUI()

        let alert = UIAlertController(
            title: "Успешно",
            message: "Ваш заказ оформлен!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)
        let item = CartManager.shared.cartItems[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = "\(item.brand) \(item.model)"
        content.secondaryText = "\(item.year) • \(String(format: "%.2f ₽", item.price))"
        cell.contentConfiguration = content
        

        cell.contentConfiguration = content

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = CartManager.shared.cartItems[indexPath.row]
            showDeleteConfirmation(for: item, at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = CartManager.shared.cartItems[indexPath.row]
        showProductDetails(item)
    }

    // MARK: - Helper Methods
    private func showDeleteConfirmation(for item: Car, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Удаление",
            message: "Удалить \(item.brand) из корзины?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            CartManager.shared.removeFromCart(at: indexPath.row)
            self?.updateUI()
        })

        present(alert, animated: true)
    }

    private func showProductDetails(_ item: Car) {
        let alert = UIAlertController(
            title: item.brand,
            message: item.description,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
        present(alert, animated: true)
    }
}
