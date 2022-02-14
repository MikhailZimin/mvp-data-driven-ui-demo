import UIKit

final class PromoViewController: UIViewController, PromoViewInput {
    var output: PromoViewOutput?

    private let promoCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collectionView
    }()

    // MARK: - Managing the ViewCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupConstraints()

        output?.viewDidLoad()
    }

    // MARK: - Managing the UI

    private func setupSubviews() {
        view.addSubview(promoCollectionView)
    }

    private var contentStackViewConstraints: [NSLayoutConstraint] {
        [
            promoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            promoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            promoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            promoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
    }

    private func setupConstraints() {
        promoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(contentStackViewConstraints)
    }

    // MARK: - Conforming of the PromoViewInput

    var collectionView: UICollectionView {
        promoCollectionView
    }

    func render(model: DataDrivenModel) {
        guard let model = model as? ViewModel else { return }

        title = model.title

        view.addAnimation(keyPath: #keyPath(UIView.backgroundColor))
        view.backgroundColor = model.backgroundColor

        if model.isCollectionHidden {
            promoCollectionView.addAnimation(keyPath: #keyPath(CALayer.opacity)) {
                self.promoCollectionView.isHidden = true
            }
            promoCollectionView.layer.opacity = 0
        } else {
            promoCollectionView.isHidden = false
            promoCollectionView.addAnimation(keyPath: #keyPath(CALayer.opacity))
            promoCollectionView.layer.opacity = 1
        }
    }

    // MARK: - Managing the ViewModel

    struct ViewModel: DataDrivenModel {
        let title: String
        let dataState: DataState

        enum DataState {
            case `default`
            case failed
        }

        // призмы
        // конвертируют состояния в проперти
        var backgroundColor: UIColor {
            switch dataState {
            case .default:
                return .darkGray
            case .failed:
                return .systemRed
            }
        }

        var isCollectionHidden: Bool {
            dataState == .failed
        }
    }
}