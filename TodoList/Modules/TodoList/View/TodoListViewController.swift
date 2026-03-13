import UIKit

final class TodoListViewController: UIViewController {
    
    var presenter: TodoListViewOutput?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = .systemFont(ofSize: 34, weight: .bold)
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
        view.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tasksCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let image = UIImage(systemName: "square.and.pencil", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.backgroundColor = .clear
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
        presenter?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let textField = searchBar.searchTextField
        if textField.rightView == nil {
            let mic = UIImageView(image: UIImage(systemName: "mic.fill"))
            mic.tintColor = .systemGray2
            mic.contentMode = .scaleAspectFit
            mic.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
            textField.rightView = mic
            textField.rightViewMode = .always
        }
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

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88

        configureSearchBar()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 83),
            
            tasksCountLabel.centerXAnchor.constraint(equalTo: bottomBarView.centerXAnchor),
            tasksCountLabel.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            
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
    }
    
    private func setupSearchController() {}

    private func configureSearchBar() {
        searchBar.backgroundImage = UIImage()
        let textField = searchBar.searchTextField
        textField.backgroundColor = UIColor(white: 0.18, alpha: 1.0)
        textField.textColor = .white
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.layer.cornerCurve = .continuous
        textField.layer.masksToBounds = true
        textField.leftView?.tintColor = .systemGray2
        textField.clearButtonMode = .never
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.systemGray2]
        )

        searchBar.showsBookmarkButton = true
        let micImage = UIImage(systemName: "mic.fill")?.withRenderingMode(.alwaysTemplate)
        searchBar.setImage(micImage, for: .bookmark, state: .normal)
        searchBar.setImage(micImage, for: .bookmark, state: .highlighted)
        searchBar.tintColor = .systemGray2
    }
    
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
        tasksCountLabel.text = "\(todos.count) Задач"
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
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        cell.onToggleCompletion = { [weak self] in
            self?.presenter?.didToggleCompletion(todo)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didTapEdit(todos[indexPath.row])
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
    
    func tableView(_ tableView: UITableView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        animator?.addAnimations {
            for cell in tableView.visibleCells {
                cell.alpha = 0.2
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        animator?.addAnimations {
            for cell in tableView.visibleCells {
                cell.alpha = 1.0
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didSearch(searchText)
    }
}
