import Foundation

final class PromoInteractor: PromoInteractorInput {
    weak var output: PromoInteractorOutput?

    private let networkService: PromoNetworkServiceInput

    init(networkService: PromoNetworkServiceInput) {
        self.networkService = networkService
    }

    // MARK: - Conforming of the PromoInteractorInput

    func fetchPromos() {
        networkService.fetchPromos { [weak self] response in
            // нужно договорится на каком потоке возвращаем итоги и кто этим занимается
            // по мне, инкапсулировать всю эту логику в интеракторе удобнее,
            // тк остальные слои не будут знать ничего, кроме main thread
            DispatchQueue.main.async {
                switch response {
                case let .success(promos):
                    self?.output?.didFetchPromos(promos)
                case let .failure(error):
                    self?.output?.fetchingDidFail(with: error)
                }
            }
        }
    }
}
