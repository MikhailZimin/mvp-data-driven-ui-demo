import UIKit

final class PromoDetailsPresenter: PromoDetailsViewOutput, PromoDetailsInteractorOutput {
    private let interactor: PromoDetailsInteractorInput
    unowned let view: PromoDetailsViewInput

    // MARK: - Managing the Initialisation

    init(interactor: PromoDetailsInteractorInput, view: PromoDetailsViewInput) {
        self.interactor = interactor
        self.view = view
    }

    // MARK: - Conforming of the PromoDetailsViewOutput

    func viewDidLoad() {
        let viewModel = makeViewModel(with: interactor.promo, state: .loading)
        view.render(model: viewModel)
        interactor.fetchPromoState()
    }

    // MARK: - Conforming of the PromoDetailsInteractorOutput

    func didFetchPromoState(_ state: Promo.State) {
        let acceptCommand = Command { [weak self] in
            guard let self = self else { return }

            let viewModel = self.makeViewModel(with: self.interactor.promo, state: .loading)
            self.view.render(model: viewModel)
            self.interactor.acceptPromo()
        }

        let state: PromoButton.ViewModel = state == .active ? .active : .pending(acceptCommand)
        let viewModel = makeViewModel(with: interactor.promo, state: state)
        view.render(model: viewModel)
    }

    func fetchingPromoStateDidFail(with error: Error) {
        let retryCommand = Command { [weak self] in
            guard let self = self else { return }

            let viewModel = self.makeViewModel(with: self.interactor.promo, state: .loading)
            self.view.render(model: viewModel)
            self.interactor.fetchPromoState()
        }

        let viewModel = makeViewModel(with: interactor.promo, state: .failed(retryCommand))
        view.render(model: viewModel)
    }

    func didAcceptPromo() {
        let viewModel = makeViewModel(with: interactor.promo, state: .active)
        view.render(model: viewModel)
    }

    func acceptingDidFail(with error: Error) {
        let retryCommand = Command { [weak self] in
            guard let self = self else { return }

            let viewModel = self.makeViewModel(with: self.interactor.promo, state: .loading)
            self.view.render(model: viewModel)
            self.interactor.fetchPromoState()
        }

        let viewModel = makeViewModel(with: interactor.promo, state: .failed(retryCommand))
        view.render(model: viewModel)
    }

    // MARK: - Making the ViewModels

    private func makeViewModel(with promo: Promo, state: PromoButton.ViewModel) -> PromoDetailsViewController.ViewModel {
        PromoDetailsViewController.ViewModel(
            screenTitle: "Подробности",
            image: UIImage(contentsOfFile: promo.imageURL.path),
            title: promo.title,
            issueDate: promo.issueDate,
            promoDescription: promo.promoDescription,
            buttonViewModel: state
        )
    }
}
