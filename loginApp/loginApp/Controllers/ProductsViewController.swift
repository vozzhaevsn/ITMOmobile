//
//  ProductsViewController.swift
//  loginApp
//
//  Created by Дмитрий Васильев on 12.11.2025.
//

import UIKit

// MARK: - Products View Controller
/// Контроллер экрана с товарами
class ProductsViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var logOutButton: UIButton!
    
    // MARK: - Properties
    var userName: String?
    private var products: [GoodsModel] = []
    private var filteredProducts: [GoodsModel] = []
    private var isSearching = false
    private var searchBar: UISearchBar?
    private let searchService = SearchService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
        loadProducts()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Товары"
        
        if tableView != nil {
            setupTableView()
        } else {
            setupTableViewProgrammatically()
        }
    }
    
    private func setupSearchBar() {
        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "Поиск товаров..."
        search.searchBarStyle = .minimal
        
        // Добавляем SearchBar в navigation bar
        navigationItem.titleView = search
        
        
        self.searchBar = search
    }
    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "GoodsCell")
        tableView?.rowHeight = 80
    }
    
    private func setupTableViewProgrammatically() {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "GoodsCell")
        table.rowHeight = 80
        
        view.insertSubview(table, at: 0)
        tableView = table
    }
    
    // MARK: - Data Loading
    private func loadProducts() {
        DatabaseService.shared.loadProducts { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let items):
                    self.products = items
                    self.filteredProducts = items
                    self.tableView?.reloadData()
                case .failure(let error):
                    self.showDataError(error)
                }
            }
        }
    }
    // MARK: - IBActions
    @IBAction func logOutButtonTapped() {
        // Handled by segue
    }
    
    @IBAction func unwindToProductsViewController(segue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCart" {
            // Cart segue - handled automatically
        }
    }
    // MARK: - Error Alert
    private func showDataError(_ error: DataError) {
        let message: String
        switch error {
        case .fileNotFound:
            message = "Файл products.json не найден в приложении."
        case .readFailed:
            message = "Не удалось прочитать данные из products.json."
        case .decodeFailed:
            message = "Ошибка разбора JSON. Проверь структуру файла и GoodsResponse."
        }
        
        let alert = UIAlertController(
            title: "Ошибка загрузки товаров",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
// MARK: - UITableViewDataSource
extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredProducts.count : products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath)
        let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = product.title
        content.secondaryText = String(format: "%.2f ₽", product.price)
        content.image = UIImage(systemName: product.image)
        content.imageProperties.tintColor = .systemBlue

        cell.contentConfiguration = content
        cell.accessoryType = .detailButton

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedProduct = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
        CartManager.shared.addToCart(selectedProduct)

        showAddedToCartAlert(for: selectedProduct)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
        showProductDetails(product)
    }

    // MARK: - Helper Methods
    private func showAddedToCartAlert(for product: GoodsModel) {
        let alert = UIAlertController(
            title: "Добавлено в корзину",
            message: "\(product.title) добавлен в корзину",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showProductDetails(_ product: GoodsModel) {
        let alert = UIAlertController(
            title: product.title,
            message: product.description,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
        present(alert, animated: true)
    }
}
// MARK: - UISearchBarDelegate
    extension ProductsViewController {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        
        if query.isEmpty {
            isSearching = false
            filteredProducts = products
        } else {
            isSearching = true
            filteredProducts = searchService.searchProducts(products, query: query)
                    }
        
        tableView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()  // Скрыть клавиатуру
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        filteredProducts = products
        tableView?.reloadData()
    }
}
