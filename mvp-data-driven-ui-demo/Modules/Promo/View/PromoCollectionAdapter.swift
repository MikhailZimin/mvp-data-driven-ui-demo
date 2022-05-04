import UIKit
import DiffableDataSources

private typealias PromoDataSource = CollectionViewDiffableDataSource<Section, PromoCellContentView.ViewModel>

private enum Section {
    case main
}

final class PromoCollectionAdapter: NSObject, DataDrivable, UICollectionViewDelegate {
    private unowned let collectionView: UICollectionView

    // использование Modern cell configuration
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, PromoCellContentView.ViewModel> { cell, indexPath, model in
        cell.contentConfiguration = model
    }

    // использование CollectionViewDiffableDataSource
    private lazy var cellProvider: PromoDataSource.CellProvider = { collectionView, indexPath, model in
        collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: model)
    }

    private lazy var dataSource = PromoDataSource(collectionView: collectionView, cellProvider: cellProvider)

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()

        collectionView.delegate = self
        collectionView.dataSource = dataSource

        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: PromoCellContentView.description())
        collectionView.collectionViewLayout = createLayout()
    }

    // MARK: - Managing the Collection Layout

    // использование UICollectionViewCompositionalLayout
    private func createLayout() -> UICollectionViewLayout {
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

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    // MARK: - Conforming of the DataDrivable

    func render(model: DataDrivenModel) {
        guard let model = model as? ViewModel else { return }

        var snapshot = DiffableDataSourceSnapshot<Section, PromoCellContentView.ViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(model.items)
        dataSource.apply(snapshot)

        // визуальная имитация изменений
        imitateChanging(with: model.items)
    }

    private func imitateChanging(with items: [PromoCellContentView.ViewModel]) {
        var completion: (([PromoCellContentView.ViewModel]) -> Void)?

        completion = { [weak self] items in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard items.count > 1 else { return }

                let count = items.count / 2
                let items: [PromoCellContentView.ViewModel] = items.dropLast(count)

                var snapshot = DiffableDataSourceSnapshot<Section, PromoCellContentView.ViewModel>()
                snapshot.appendSections([.main])
                snapshot.appendItems(items)

                self?.dataSource.apply(snapshot)
                completion?(items)
            }
        }

        completion?(items)
    }

    // MARK: - Conforming of the UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource.itemIdentifier(for: indexPath)?.action?.execute()
    }

    // MARK: - Managing the ViewModel

    struct ViewModel: DataDrivenModel {
        let items: [PromoCellContentView.ViewModel]
    }

    // MARK: - Managing the Constants

    private enum Constants {
        static let contentStackViewSpacing: CGFloat = 12
        static let contentStackViewOffset: CGFloat = 10
        static let columnSpacing: CGFloat = 1
        static let rowSpacing: CGFloat = 1
    }
}
