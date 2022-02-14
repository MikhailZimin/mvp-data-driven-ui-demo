import UIKit

final class PromoDetailsViewController: UIViewController, PromoDetailsViewInput {
    var output: PromoDetailsViewOutput?

    private let detailsScrollView = UIScrollView()

    private let detailsContentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.detailsSpacing

        return stackView
    }()

    private let promoImageView = UIImageView()

    private let promoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)

        return label
    }()

    private let promoIssueDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)

        return label
    }()

    private let promoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    private let actionButton = PromoButton()

    // MARK: - Managing the ViewCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSubviews()
        setupConstraints()

        output?.viewDidLoad()
    }

    // MARK: - Managing the UI

    private func setupView() {
        view.backgroundColor = .darkGray
    }

    private func setupSubviews() {
        view.addSubview(detailsScrollView)
        detailsScrollView.addSubview(detailsContentView)

        [
            promoImageView,
            promoTitleLabel,
            promoIssueDateLabel,
            promoDescriptionLabel,
            actionButton
        ].forEach { detailsContentView.addArrangedSubview($0) }
    }

    var detailsScrollViewConstraints: [NSLayoutConstraint] {
        [
            detailsScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
    }

    var detailsContentViewConstraints: [NSLayoutConstraint] {
        [
            detailsContentView.topAnchor.constraint(equalTo: detailsScrollView.topAnchor),
            detailsContentView.leadingAnchor.constraint(equalTo: detailsScrollView.leadingAnchor),
            detailsContentView.trailingAnchor.constraint(equalTo: detailsScrollView.trailingAnchor),
            detailsContentView.bottomAnchor.constraint(equalTo: detailsScrollView.bottomAnchor),
            detailsContentView.widthAnchor.constraint(equalTo: detailsScrollView.widthAnchor)
        ]
    }

    private var promoImageViewConstraints: [NSLayoutConstraint] {
        [
            promoImageView.widthAnchor.constraint(equalTo: promoImageView.heightAnchor,
                                                  multiplier: Constants.imageAspectRatio)
        ]
    }

    private func setupConstraints() {
        [
            detailsScrollView,
            detailsContentView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate(
            promoImageViewConstraints +
            detailsScrollViewConstraints +
            detailsContentViewConstraints
        )
    }

    // MARK: - Conforming of the PromoDetailsViewInput

    func render(model: DataDrivenModel) {
        guard let model = model as? ViewModel else { return }

        title = model.screenTitle
        promoImageView.image = model.image
        promoTitleLabel.text = model.title
        promoIssueDateLabel.text = model.issueDate
        promoDescriptionLabel.text = model.promoDescription

        actionButton.render(model: model.buttonViewModel)
    }

    // MARK: - Managing the ViewModel

    struct ViewModel: DataDrivenModel {
        let screenTitle: String
        let image: UIImage?
        let title: String
        let issueDate: String
        let promoDescription: String
        let buttonViewModel: PromoButton.ViewModel
    }

    // MARK: - Managing the Constants

    private enum Constants {
        static let detailsSpacing: CGFloat = 10
        static let imageAspectRatio: CGFloat = 600.0 / 424
    }
}
