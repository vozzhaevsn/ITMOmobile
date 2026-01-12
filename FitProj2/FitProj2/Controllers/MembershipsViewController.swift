import UIKit

// MARK: - Memberships View Controller
/// Экран со списком абонементов
class MembershipsViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var logOutButton: UIButton!
    
    // MARK: - Properties
    var userName: String?
    private var memberships: [Membership] = []
    private var filteredMemberships: [Membership] = []
    private var isSearching = false
    private var searchBar: UISearchBar?
    private let searchService = SearchService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
        loadMemberships()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Абонементы"
        
        if tableView != nil {
            setupTableView()
        } else {
            setupTableViewProgrammatically()
        }
    }
    
    private func setupSearchBar() {
        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "Поиск абонементов..."
        search.searchBarStyle = .minimal
        
        // SearchBar в navigation bar
        navigationItem.titleView = search
        self.searchBar = search
    }
    
    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "MembershipCell")
        tableView?.rowHeight = 80
    }
    
    private func setupTableViewProgrammatically() {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MembershipCell")
        table.rowHeight = 80
        
        view.insertSubview(table, at: 0)
        tableView = table
    }
    
    // MARK: - Data Loading
    private func loadMemberships() {
        FitnessDatabaseService.shared.loadMemberships { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let items):
                    self.memberships = items
                    self.filteredMemberships = items
                    self.tableView?.reloadData()
                case .failure:
                    break
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
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
extension MembershipsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredMemberships.count : memberships.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipCell", for: indexPath)
        let item = isSearching ? filteredMemberships[indexPath.row] : memberships[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = "\(item.duration) • \(String(format: "%.0f ₽", item.price))"
        
        cell.contentConfiguration = content
        cell.accessoryType = .detailButton
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MembershipsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = isSearching ? filteredMemberships[indexPath.row] : memberships[indexPath.row]
        
        // Добавляем абонемент в корзину
        CartManager.shared.addToCart(item)
        print("Added to cart:", item.title)
        
        let alert = UIAlertController(
            title: "Добавлено в корзину",
            message: "\(item.title)\n\(item.duration), \(Int(item.price)) ₽",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let item = isSearching ? filteredMemberships[indexPath.row] : memberships[indexPath.row]
        
        let alert = UIAlertController(
            title: item.title,
            message: item.description,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension MembershipsViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        
        if query.isEmpty {
            isSearching = false
            filteredMemberships = memberships
        } else {
            isSearching = true
            filteredMemberships = searchService.searchMemberships(memberships, query: query)
        }
        
        tableView?.reloadData()
    }
}
