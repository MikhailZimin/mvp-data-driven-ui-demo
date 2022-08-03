// принцип:
// Input – команда на выполнение
// Output – оповещение о том, что что-то случилось

import UIKit

protocol PromoModuleOutput: AnyObject {
    func didSelectPromo(_ promo: Promo)
}

protocol PromoInteractorInput {
    var canFetchNextPage: Bool { get }

    func fetchPromos()
}

protocol PromoInteractorOutput: AnyObject {
    func didFetchPromos(_ promos: [Promo])
    func fetchingDidFail(with error: Error)
}

protocol PromoViewInput: AnyObject {
    var collectionView: UICollectionView { get }

    func render(model: PromoViewController.ViewModel)
}

protocol PromoViewOutput {
    func viewDidLoad()
}
