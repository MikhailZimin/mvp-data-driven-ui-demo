import UIKit

final class PromoPresenter: PromoViewOutput, PromoInteractorOutput {
    private let interactor: PromoInteractorInput
    unowned let view: PromoViewInput
    private let promoCollectionAdapter: DataDrivable
    private let viewModelsBuilder: PromoViewModelsBuilder
    weak var output: PromoModuleOutput?

    // MARK: - Managing the Initialisation

    init(
        interactor: PromoInteractorInput,
        view: PromoViewInput,
        collectionAdapter: DataDrivable,
        viewModelsBuilder: PromoViewModelsBuilder,
        output: PromoModuleOutput?
    ) {
        self.interactor = interactor
        self.view = view
        self.promoCollectionAdapter = collectionAdapter
        self.viewModelsBuilder = viewModelsBuilder
        self.output = output
    }

    // MARK: - Conforming of the PromoViewOutput

    func viewDidLoad() {
        viewModelsBuilder.makeViewModel(isFetchingFailed: false) { [weak self] viewModel in
            self?.view.render(model: viewModel)
        }

        interactor.fetchPromos()
    }

    // MARK: - Conforming of the PromoInteractorOutput

    func didFetchPromos(_ promos: [Promo]) {
        viewModelsBuilder.makeViewModel(isFetchingFailed: false) { [weak self] viewModel in
            self?.view.render(model: viewModel)
        }

        viewModelsBuilder.makeAdapterViewModel(
            from: promos,
            commandAction: { [weak self] in self?.goToPromoDetails(with: $0) }
        ) { [weak self] adapterViewModel in
            self?.promoCollectionAdapter.render(model: adapterViewModel)
        }
    }

    func fetchingDidFail(with error: Error) {
        viewModelsBuilder.makeViewModel(isFetchingFailed: true) { [weak self] viewModel in
            self?.view.render(model: viewModel)
        }
    }

    // MARK: - Managing the Routing

    private func goToPromoDetails(with promo: Promo) {
        output?.didSelectPromo(promo)
    }
}
