enum PromoDetailsModuleFactory {
    static func makeModule(promo: Promo) -> PromoDetailsViewController {
        let networkService = PromoDetailsNetworkService()
        let interactor = PromoDetailsInteractor(promo: promo, networkService: networkService)
        let viewModelBuilder = PromoDetailsViewModelBuilder()

        let viewController = PromoDetailsViewController()
        let presenter = PromoDetailsPresenter(
            interactor: interactor,
            view: viewController,
            viewModelBuilder: viewModelBuilder
        )

        viewController.output = presenter
        interactor.output = presenter

        return viewController
    }
}
