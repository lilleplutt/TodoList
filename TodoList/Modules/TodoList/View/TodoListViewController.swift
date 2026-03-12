import UIKit

final class TodoListViewController: UIViewController {
    
    var presenter: TodoListViewOutput?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .clear
        return table
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет задач"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tasksCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.pencil")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var todos: [Todo] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupSearchController()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(tasksCountLabel)
        bottomBarView.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 64),
            
            tasksCountLabel.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            tasksCountLabel.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 24),
            
            addButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -24),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = nil
        
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.tintColor = .systemYellow
        }
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            let micImageView = UIImageView(image: UIImage(systemName: "mic.fill"))
            micImageView.tintColor = .systemGray2
            micImageView.contentMode = .scaleAspectFit
            micImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            textField.rightView = micImageView
            textField.rightViewMode = .always
        }
    }
    
    private func setupSearchController() {}
    
    // MARK: - Actions
    @objc private func didTapAdd() {
        presenter?.didTapAddTodo()
    }
}

// MARK: - TodoListViewInput
extension TodoListViewController: TodoListViewInput {
    
    func showTodos(_ todos: [Todo]) {
        self.todos = todos
        emptyLabel.isHidden = !todos.isEmpty
        tasksCountLabel.text = "\(todos.count) задач"
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        cell.configure(with: todos[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let todo = todos[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else { return UIMenu() }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.presenter?.didTapEdit(todo)
            }
            
            let shareText = todo.description.isEmpty ? todo.title : "\(todo.title)\n\(todo.description)"
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                self.present(activityVC, animated: true)
            }

            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.presenter?.didTapDelete(todo)
            }

            let primary = UIMenu(options: .displayInline, children: [editAction, shareAction])
            let destructive = UIMenu(options: .displayInline, children: [deleteAction])
            
            return UIMenu(children: [primary, destructive])
        }
    }
}

// MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didSearch(searchText)
    }
}

