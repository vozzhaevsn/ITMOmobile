import UIKit

// MARK: - Cars View Controller
/// Экран со списком автомобилей
class CarsViewController: UIViewController, UISearchBarDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var logOutButton: UIButton!

    // MARK: - Properties
    var userName: String?
    private var cars: [Car] = []
    private var filteredCars: [Car] = []
    private var isSearching = false
    private var searchBar: UISearchBar?
    private let searchService = SearchService()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
        loadCars()
    }

    // MARK: - Setup
    private func setupUI() {
        title = "Каталог автомобилей"

        if tableView != nil {
            setupTableView()
        } else {
            setupTableViewProgrammatically()
        }
    }

    private func setupSearchBar() {
        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "Поиск автомобилей..."
        search.searchBarStyle = .minimal

        navigationItem.titleView = search
        self.searchBar = search
    }

    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "CarCell")
        tableView?.rowHeight = 80
    }

    private func setupTableViewProgrammatically() {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CarCell")
        table.rowHeight = 80

        view.insertSubview(table, at: 0)
        tableView = table
    }

    // MARK: - Data Loading
    private func loadCars() {
        CarDatabaseService.shared.loadCars { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let items):
                    self.cars = items
                    self.filteredCars = items
                    self.tableView?.reloadData()
                case .failure:
                    // здесь можно показать алерт об ошибке загрузки
                    break
                }
            }
        }
    }

    // MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        User.clear()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        ) as? LoginViewController else {
            return
        }

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = UINavigationController(rootViewController: loginVC)
            window.makeKeyAndVisible()
        }
    }
}

// MARK: - UITableViewDataSource
extension CarsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredCars.count : cars.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath)
        let item = isSearching ? filteredCars[indexPath.row] : cars[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = "\(item.brand) \(item.model)"
        content.secondaryText = "\(item.year) • \(String(format: "%.0f ₽", item.price))"

        cell.contentConfiguration = content
        cell.accessoryType = .detailButton

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CarsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = isSearching ? filteredCars[indexPath.row] : cars[indexPath.row]

        CartManager.shared.addToCart(item)
        print("Added to cart:", item.brand, item.model)

        let message = "\(item.brand) \(item.model)\n\(item.year), \(Int(item.price)) ₽"
        let alert = UIAlertController(
            title: "Добавлено в корзину",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   accessoryButtonTappedForRowWith indexPath: IndexPath) {

        let item = isSearching ? filteredCars[indexPath.row] : cars[indexPath.row]

        let alert = UIAlertController(
            title: "\(item.brand) \(item.model)",
            message: item.description,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension CarsViewController {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText.trimmingCharacters(in: .whitespaces)

        if query.isEmpty {
            isSearching = false
            filteredCars = cars
        } else {
            isSearching = true
            filteredCars = searchService.searchCars(cars, query: query)
        }

        tableView?.reloadData()
    }
}
