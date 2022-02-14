import Foundation

final class PromoDetailsInteractor: PromoDetailsInteractorInput {
    weak var output: PromoDetailsInteractorOutput?

    let promo: Promo
    private let networkService: PromoDetailsNetworkServiceInput

    init(promo: Promo, networkService: PromoDetailsNetworkServiceInput) {
        self.promo = promo
        self.networkService = networkService
    }

    // MARK: - Conforming of the PromoDetailsInteractorInput

    func fetchPromoState() {
        networkService.fetchPromoState { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case let .success(state):
                    self?.output?.didFetchPromoState(state)
                case let .failure(error):
                    self?.output?.fetchingPromoStateDidFail(with: error)
                }
            }
        }
    }

    func acceptPromo() {
        networkService.acceptPromo { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success:
                    self?.output?.didAcceptPromo()
                case let .failure(error):
                    self?.output?.acceptingDidFail(with: error)
                }
            }
        }
    }
}
