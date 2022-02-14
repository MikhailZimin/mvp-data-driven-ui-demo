// принцип:
// Input – команда на выполнение
// Output – оповещение о том, что что-то случилось

import UIKit

protocol PromoModuleOutput: AnyObject {
    func didSelectPromo(_ promo: Promo)
}

protocol PromoInteractorInput {
    func fetchPromos()
}

protocol PromoInteractorOutput: AnyObject {
    func didFetchPromos(_ promos: [Promo])
    func fetchingDidFail(with error: Error)
}

protocol PromoViewInput: DataDrivable {
    var collectionView: UICollectionView { get }
}

protocol PromoViewOutput {
    func viewDidLoad()
}
