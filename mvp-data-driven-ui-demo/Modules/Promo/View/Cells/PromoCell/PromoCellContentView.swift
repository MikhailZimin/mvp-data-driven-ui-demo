import UIKit

final class PromoCellContentView: UIView, UIContentView, DataDrivable {
    // инкапсуляция настройки вью в месте, где она создается
    // уменьшает и делает код понятнее в методах типа setupView()
    // при необходимости можно использовать lazy var
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constants.contentStackViewSpacing
        stackView.axis = .vertical
        stackView.alignment = .center

        return stackView
    }()

    private let promoImageView = UIImageView()

    private let promoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)

        return label
    }()

    private var currentConfiguration = ViewModel(imageURL: nil, title: "", action: nil)

    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }

        set {
            guard let newConfiguration = newValue as? ViewModel else { return }

            render(model: newConfiguration)
        }
    }

    // MARK: - Managing the Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupView()
        setupSubviews()
        setupConstraints()
    }

    // MARK: - Managing the UI

    private func setupView() {
        backgroundColor = .darkGray
    }

    private func setupSubviews() {
        addSubview(containerStackView)

        [
            promoImageView,
            promoTitleLabel
        ].forEach { containerStackView.addArrangedSubview($0) }
    }

    private var promoImageViewConstraints: [NSLayoutConstraint] {
        [
            promoImageView.widthAnchor.constraint(equalTo: promoImageView.heightAnchor,
                                                  multiplier: Constants.imageAspectRatio)
        ]
    }

    private var containerStackViewConstraints: [NSLayoutConstraint] {
        [
            containerStackView.topAnchor.constraint(equalTo: topAnchor,
                                                    constant: Constants.containerStackViewOffset),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                        constant: Constants.containerStackViewOffset),
            trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor,
                                      constant: Constants.containerStackViewOffset),
            bottomAnchor.constraint(equalTo: containerStackView.bottomAnchor,
                                    constant: Constants.containerStackViewOffset)
        ]
    }

    private func setupConstraints() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            promoImageViewConstraints +
            containerStackViewConstraints
        )
    }

    // MARK: - Conforming of the DataDrivable

    func render(model: DataDrivenModel) {
        guard let model = model as? ViewModel else { return }

        currentConfiguration = model

        model.imageURL.flatMap { promoImageView.image = UIImage(contentsOfFile: $0.path) }
        promoTitleLabel.text = model.title
    }

    // MARK: - Managing the Constants

    private enum Constants {
        static let contentStackViewSpacing: CGFloat = 12
        static let containerStackViewOffset: CGFloat = 10
        static let imageAspectRatio: CGFloat = 600.0 / 424
    }
}
