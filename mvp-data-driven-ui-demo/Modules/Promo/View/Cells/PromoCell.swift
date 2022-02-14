import UIKit

final class PromoCell: UICollectionViewCell, DataDrivable {
    // инкапсуляция настройки вью в месте, где она создается
    // уменьшает и делает код понятнее в методах на подобии setupView()
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
        contentView.addSubview(containerStackView)

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
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: Constants.containerStackViewOffset),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                        constant: Constants.containerStackViewOffset),
            contentView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor,
                                                  constant: Constants.containerStackViewOffset),
            contentView.bottomAnchor.constraint(equalTo: containerStackView.bottomAnchor,
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

        promoImageView.image = model.image
        promoTitleLabel.text = model.title
    }

    // MARK: - Managing the ViewModel

    struct ViewModel: DataDrivenModel {
        let image: UIImage?
        let title: String
        let action: Command
    }

    // MARK: - Managing the Constants

    private enum Constants {
        static let contentStackViewSpacing: CGFloat = 12
        static let containerStackViewOffset: CGFloat = 10
        static let imageAspectRatio: CGFloat = 600.0 / 424
    }
}
