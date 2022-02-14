import UIKit

typealias CollectionAdapterProtocol = UICollectionViewDelegate & UICollectionViewDataSource

final class PromoCollectionAdapter: NSObject, DataDrivable, CollectionAdapterProtocol {
    private unowned let collectionView: UICollectionView
    private var viewModels = [PromoCell.ViewModel]()

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(PromoCell.self, forCellWithReuseIdentifier: PromoCell.description())
        collectionView.collectionViewLayout = createLayout()
    }

    // MARK: - Managing the Collection Layout

    // использовать UICollectionViewCompositionalLayout, если откажемся от iOS 12
    // он умеет в autosize
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

        viewModels = model.items
        collectionView.reloadData()
    }

    // MARK: - Conforming of the UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModels[indexPath.item].action.execute()
    }

    // MARK: - Conforming of the UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCell.description(), for: indexPath)

        if let cell = cell as? PromoCell {
            cell.render(model: viewModels[indexPath.item])
        }

        return cell
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
