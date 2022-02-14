enum PromoDetailsModuleFactory {
    static func makeModule(promo: Promo) -> PromoDetailsViewController {
        let networkService = PromoDetailsNetworkService()
        let interactor = PromoDetailsInteractor(promo: promo, networkService: networkService)

        let viewController = PromoDetailsViewController()
        let presenter = PromoDetailsPresenter(interactor: interactor, view: viewController)

        viewController.output = presenter
        interactor.output = presenter

        return viewController
    }
}
