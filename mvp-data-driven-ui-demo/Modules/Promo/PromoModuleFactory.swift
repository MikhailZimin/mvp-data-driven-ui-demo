enum PromoModuleFactory {
    static func makeModule(output: PromoModuleOutput?) -> PromoViewController {
        let networkService = PromoNetworkService()
        let interactor = PromoInteractor(networkService: networkService)

        let viewController = PromoViewController()
        let collectionAdapter = PromoCollectionAdapter(collectionView: viewController.collectionView)

        let presenter = PromoPresenter(
            interactor: interactor,
            view: viewController,
            collectionAdapter: collectionAdapter,
            output: output
        )

        viewController.output = presenter
        interactor.output = presenter

        return viewController
    }
}
