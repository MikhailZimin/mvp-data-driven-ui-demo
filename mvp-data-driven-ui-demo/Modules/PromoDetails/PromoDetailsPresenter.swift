import UIKit

final class PromoDetailsPresenter: PromoDetailsViewOutput, PromoDetailsInteractorOutput {
    private let interactor: PromoDetailsInteractorInput
    unowned let view: PromoDetailsViewInput
    private let viewModelBuilder: PromoDetailsViewModelBuilder

    // MARK: - Managing the Initialisation

    init(
        interactor: PromoDetailsInteractorInput,
        view: PromoDetailsViewInput,
        viewModelBuilder: PromoDetailsViewModelBuilder
    ) {
        self.interactor = interactor
        self.view = view
        self.viewModelBuilder = viewModelBuilder
    }

    // MARK: - Conforming of the PromoDetailsViewOutput

    func viewDidLoad() {
        makeViewModel(state: .loading)
        interactor.fetchPromoState()
    }

    // MARK: - Conforming of the PromoDetailsInteractorOutput

    func didFetchPromoState(_ state: Promo.State) {
        let acceptCommand = Command { [weak self] in
            guard let self = self else { return }

            self.makeViewModel(state: .loading)
            self.interactor.acceptPromo()
        }

        let state: PromoButton.ViewModel = state == .active ? .active : .pending(acceptCommand)
        makeViewModel(state: state)
    }

    func fetchingPromoStateDidFail(with error: Error) {
        let retryCommand = Command { [weak self] in
            guard let self = self else { return }

            self.makeViewModel(state: .loading)
            self.interactor.fetchPromoState()
        }

        makeViewModel(state: .failed(retryCommand))
    }

    func didAcceptPromo() {
        makeViewModel(state: .active)
    }

    func acceptingDidFail(with error: Error) {
        let retryCommand = Command { [weak self] in
            guard let self = self else { return }

            self.makeViewModel(state: .loading)
            self.interactor.fetchPromoState()
        }

        makeViewModel(state: .failed(retryCommand))
    }

    // MARK: - Making the ViewModels

    private func makeViewModel(state: PromoButton.ViewModel) {
        viewModelBuilder.makeViewModel(
            with: interactor.promo,
            state: state
        ) { [weak self] viewModel in
            self?.view.render(model: viewModel)
        }
    }
}
