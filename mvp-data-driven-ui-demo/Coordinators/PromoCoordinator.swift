import UIKit

final class PromoCoordinator: PromoModuleOutput {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let promoViewController = PromoModuleFactory.makeModule(output: self)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([promoViewController], animated: false)
    }

    // MARK: - Conforming of the PromoModuleOutput

    func didSelectPromo(_ promo: Promo) {
        let viewController = PromoDetailsModuleFactory.makeModule(promo: promo)
        navigationController.pushViewController(viewController, animated: true)
    }
}
