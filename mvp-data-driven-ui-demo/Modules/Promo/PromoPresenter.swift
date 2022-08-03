import UIKit

final class PromoPresenter: PromoViewOutput, PromoInteractorOutput {
    private let interactor: PromoInteractorInput
    unowned let view: PromoViewInput
    private let promoCollectionAdapter: PromoCollectionAdapterInput
    private let viewModelBuilder: PromoViewModelBuilder
    weak var output: PromoModuleOutput?

    // MARK: - Managing the Initialisation

    init(
        interactor: PromoInteractorInput,
        view: PromoViewInput,
        collectionAdapter: PromoCollectionAdapterInput,
        viewModelBuilder: PromoViewModelBuilder,
        output: PromoModuleOutput?
    ) {
        self.interactor = interactor
        self.view = view
        self.promoCollectionAdapter = collectionAdapter
        self.viewModelBuilder = viewModelBuilder
        self.output = output
    }

    // MARK: - Conforming of the PromoViewOutput

    func viewDidLoad() {
        viewModelBuilder.makeViewModel(isFetchingFailed: false) { [weak self] viewModel in
            self?.view.render(model: viewModel)
        }

        interactor.fetchPromos()
    }

    // MARK: - Conforming of the PromoInteractorOutput

    func didFetchPromos(_ promos: [Promo]) {
        viewModelBuilder.makeViewModel(isFetchingFailed: false) { [weak self] viewModel in
            self?.view.render(model: viewModel)
        }

        viewModelBuilder.makeAdapterViewModel(
            from: promos,
            onItemTapCommand: CommandWith<Promo> { [weak self] in self?.goToPromoDetails(with: $0) },
            onScrollToEndCommand: interactor.canFetchNextPage ? Command { [weak self] in self?.handleOnScrollToEndAction() } : nil
        ) { [weak self] adapterViewModel in
            self?.promoCollectionAdapter.render(model: adapterViewModel)
        }
    }

    func fetchingDidFail(with error: Error) {
        viewModelBuilder.makeViewModel(isFetchingFailed: true) { [weak self] viewModel in
            self?.view.render(model: viewModel)

            // mock retry
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.interactor.fetchPromos()
            }
        }
    }

    private func handleOnScrollToEndAction() {
        interactor.fetchPromos()
    }

    // MARK: - Managing the Routing

    private func goToPromoDetails(with promo: Promo) {
        output?.didSelectPromo(promo)
    }
}
