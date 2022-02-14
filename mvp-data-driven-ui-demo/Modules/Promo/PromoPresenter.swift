import UIKit

final class PromoPresenter: PromoViewOutput, PromoInteractorOutput {
    private let interactor: PromoInteractorInput
    unowned let view: PromoViewInput
    private let promoCollectionAdapter: DataDrivable
    weak var output: PromoModuleOutput?

    // MARK: - Managing the Initialisation

    init(
        interactor: PromoInteractorInput,
        view: PromoViewInput,
        collectionAdapter: DataDrivable,
        output: PromoModuleOutput?
    ) {
        self.interactor = interactor
        self.view = view
        self.promoCollectionAdapter = collectionAdapter
        self.output = output
    }

    // MARK: - Conforming of the PromoViewOutput

    func viewDidLoad() {
        let viewModel = makeViewModel(isFetchingFailed: false)
        view.render(model: viewModel)

        interactor.fetchPromos()
    }

    // MARK: - Conforming of the PromoInteractorOutput

    func didFetchPromos(_ promos: [Promo]) {
        let viewModel = makeViewModel(isFetchingFailed: false)
        view.render(model: viewModel)

        let adapterViewModel = makeAdapterViewModel(from: promos)
        promoCollectionAdapter.render(model: adapterViewModel)
    }

    func fetchingDidFail(with error: Error) {
        let viewModel = makeViewModel(isFetchingFailed: true)
        view.render(model: viewModel)
    }

    // MARK: - Making the ViewModels

    private func makeViewModel(isFetchingFailed: Bool) -> PromoViewController.ViewModel {
        PromoViewController.ViewModel(
            title: "Promo",
            dataState: isFetchingFailed ? .failed : .default
        )
    }

    private func makeAdapterViewModel(from promos: [Promo]) -> PromoCollectionAdapter.ViewModel {
        let items = promos.map { promo in
            PromoCell.ViewModel(
                image: UIImage(contentsOfFile: promo.imageURL.path),
                title: promo.title,
                action: Command { [weak self] in self?.goToPromoDetails(with: promo) }
            )
        }

        return PromoCollectionAdapter.ViewModel(items: items)
    }

    // MARK: - Managing the Routing

    private func goToPromoDetails(with promo: Promo) {
        output?.didSelectPromo(promo)
    }
}
