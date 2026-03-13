import UIKit

final class TodoDetailViewController: UIViewController {
    
    var presenter: TodoDetailViewOutput?
    private var isEditingTodo = false
    
    // MARK: - UI Elements
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название задачи"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 34, weight: .bold)
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание задачи"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        descriptionTextView.addSubview(placeholderLabel)
        descriptionTextView.delegate = self
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = makeBackButton()
        
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

    private func makeBackButton() -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle(" Назад", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.tintColor = .systemYellow
        button.setTitleColor(.systemYellow, for: .normal)
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    // MARK: - Actions
    private func saveIfNeeded() {
        guard let title = titleTextField.text, !title.isEmpty else {
            if isEditingTodo {
                showError("Введите название задачи")
            } else {
                presenter?.didTapCancel()
            }
            return
        }
        let description = descriptionTextView.text ?? ""
        presenter?.didTapSave(title: title, description: description)
    }
    
    @objc private func didTapBack() {
        saveIfNeeded()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TodoDetailViewInput
extension TodoDetailViewController: TodoDetailViewInput {
    
    func showTodo(_ todo: Todo) {
        isEditingTodo = true
        titleTextField.text = todo.title
        descriptionTextView.text = todo.description
        placeholderLabel.isHidden = !todo.description.isEmpty
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        dateLabel.text = formatter.string(from: todo.createdAt)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension TodoDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
