import UIKit
import DiffableDataSources

private typealias PromoDataSource = CollectionViewDiffableDataSource<Section, PromoCellContentView.ViewModel>

private enum Section {
    case main
}

final class PromoCollectionAdapter: NSObject, DataDrivable, UICollectionViewDelegate {
    private unowned let collectionView: UICollectionView
    private var hasFooter = true
    private var onScrollToEndAction: Command?

    // использование Modern cell configuration
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, PromoCellContentView.ViewModel> { cell, indexPath, model in
        cell.contentConfiguration = model
    }

    private let footerRegistration = UICollectionView.SupplementaryRegistration<PromoListFooterView>(elementKind: PromoListFooterView.description()) { _, _, _ in }

    // использование CollectionViewDiffableDataSource
    private lazy var cellProvider: PromoDataSource.CellProvider = { collectionView, indexPath, model in
        collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: model)
    }

    private lazy var footerProvider: PromoDataSource.SupplementaryViewProvider = { collectionView, _, indexPath in
        collectionView.dequeueConfiguredReusableSupplementary(using: self.footerRegistration, for: indexPath)
    }

    private lazy var dataSource: PromoDataSource = {
        let dataSource = PromoDataSource(collectionView: collectionView, cellProvider: cellProvider)
        dataSource.supplementaryViewProvider = footerProvider

        return dataSource
    }()

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()

        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
    }

    // MARK: - Managing the Collection Layout

    // использование UICollectionViewCompositionalLayout
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            group.interItemSpacing = .fixed(Constants.columnSpacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = Constants.rowSpacing

            if self?.hasFooter == true {
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: PromoListFooterView.description(),
                    alignment: .bottom
                )
                section.boundarySupplementaryItems = [sectionFooter]
            }

            return section
        }
    }

    // MARK: - Conforming of the DataDrivable

    func render(model: DataDrivenModel) {
        guard let model = model as? ViewModel else { return }

        hasFooter = model.hasFooter
        onScrollToEndAction = model.onScrollToEndAction

        var snapshot = DiffableDataSourceSnapshot<Section, PromoCellContentView.ViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(model.items)
        dataSource.apply(snapshot)
    }

    // MARK: - Conforming of the UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource.itemIdentifier(for: indexPath)?.action?.execute()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        (view as? PromoListFooterView)?.startAnimating()
        onScrollToEndAction?.execute()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        (view as? PromoListFooterView)?.stopAnimating()
    }

    // MARK: - Managing the ViewModel

    struct ViewModel: DataDrivenModel {
        let items: [PromoCellContentView.ViewModel]
        let hasFooter: Bool
        let onScrollToEndAction: Command?
    }

    // MARK: - Managing the Constants

    private enum Constants {
        static let contentStackViewSpacing: CGFloat = 12
        static let contentStackViewOffset: CGFloat = 10
        static let columnSpacing: CGFloat = 1
        static let rowSpacing: CGFloat = 1
    }
}
