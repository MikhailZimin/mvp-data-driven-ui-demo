import UIKit
import DiffableDataSources

private typealias PromoDataSource = CollectionViewDiffableDataSource<Section, PromoCell.ViewModel>

private enum Section {
    case main
}

final class PromoCollectionAdapter: NSObject, DataDrivable, UICollectionViewDelegate {
    private unowned let collectionView: UICollectionView

    // использование CollectionViewDiffableDataSource
    private lazy var cellProvider: PromoDataSource.CellProvider = { collectionView, indexPath, model in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCell.description(), for: indexPath)
        (cell as? PromoCell)?.render(model: model)

        return cell
    }

    private lazy var dataSource = PromoDataSource(collectionView: collectionView, cellProvider: cellProvider)

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()

        collectionView.delegate = self
        collectionView.dataSource = dataSource

        collectionView.register(PromoCell.self, forCellWithReuseIdentifier: PromoCell.description())
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

        var snapshot = DiffableDataSourceSnapshot<Section, PromoCell.ViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(model.items)
        dataSource.apply(snapshot)

        // визуальная имитация изменений
        imitateChanging(with: model.items)
    }

    private func imitateChanging(with items: [PromoCell.ViewModel]) {
        var completion: (([PromoCell.ViewModel]) -> Void)?

        completion = { [weak self] items in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard items.count > 1 else { return }

                let count = items.count / 2
                let items: [PromoCell.ViewModel] = items.dropLast(count)

                var snapshot = DiffableDataSourceSnapshot<Section, PromoCell.ViewModel>()
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
        dataSource.itemIdentifier(for: indexPath)?.action.execute()
    }

    // MARK: - Managing the ViewModel

    struct ViewModel: DataDrivenModel {
        let items: [PromoCell.ViewModel]
    }

    // MARK: - Managing the Constants

    private enum Constants {
        static let contentStackViewSpacing: CGFloat = 12
        static let contentStackViewOffset: CGFloat = 10
        static let columnSpacing: CGFloat = 1
        static let rowSpacing: CGFloat = 1
    }
}
