import UIKit

final class TodoCell: UITableViewCell {
    
    static let identifier = "TodoCell"
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkmarkView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.35)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(checkmarkView)
        contentView.addSubview(separatorView)

        checkmarkView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCheckmark))
        checkmarkView.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkmarkView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6),
            checkmarkView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            checkmarkView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    // MARK: - Configure
    func configure(with todo: Todo) {
        let lightGray = UIColor(white: 1.0, alpha: 0.6)
        if todo.isCompleted {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: lightGray
            ]
            titleLabel.attributedText = NSAttributedString(string: todo.title, attributes: attributes)
        } else {
            titleLabel.attributedText = NSAttributedString(string: todo.title, attributes: [
                .foregroundColor: UIColor.white
            ])
        }

        descriptionLabel.text = todo.description.isEmpty ? "Нет описания" : todo.description
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        dateLabel.text = formatter.string(from: todo.createdAt)
        
        let imageName = todo.isCompleted ? "checkmark.circle" : "circle"
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        checkmarkView.image = UIImage(systemName: imageName, withConfiguration: symbolConfig)
        checkmarkView.tintColor = todo.isCompleted ? .systemYellow : .systemGray2
        
        if todo.isCompleted {
            descriptionLabel.textColor = lightGray
            dateLabel.textColor = lightGray
        } else {
            descriptionLabel.textColor = .white
            dateLabel.textColor = lightGray
        }

        descriptionLabel.alpha = 1.0
        dateLabel.alpha = 1.0
    }

    var onToggleCompletion: (() -> Void)?

    @objc private func didTapCheckmark() {
        onToggleCompletion?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onToggleCompletion = nil
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let changes = {
            self.containerView.backgroundColor = highlighted ? UIColor(white: 0.15, alpha: 1.0) : .clear
        }
        animated ? UIView.animate(withDuration: 0.2, animations: changes) : changes()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let changes = {
            self.containerView.backgroundColor = selected ? UIColor(white: 0.15, alpha: 1.0) : .clear
        }
        animated ? UIView.animate(withDuration: 0.2, animations: changes) : changes()
    }
}
