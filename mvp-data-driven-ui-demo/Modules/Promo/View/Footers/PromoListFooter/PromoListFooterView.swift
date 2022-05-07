import UIKit

final class PromoListFooterView: UICollectionReusableView {
    private let activityIndicator = UIActivityIndicatorView()

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
        backgroundColor = .clear
    }

    private func setupSubviews() {
        addSubview(activityIndicator)
    }

    private var activityIndicatorConstraints: [NSLayoutConstraint] {
        [
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalOffset),
            bottomAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: Constants.verticalOffset)
        ]
    }

    private func setupConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(activityIndicatorConstraints)
    }

    func startAnimating() {
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
    }

    // MARK: - Managing the Constants

    private enum Constants {
        static let verticalOffset: CGFloat = 16
    }
}
