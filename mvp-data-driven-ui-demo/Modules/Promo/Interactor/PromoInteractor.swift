import Foundation

final class PromoInteractor: PromoInteractorInput {
    weak var output: PromoInteractorOutput?

    private var hasNext = true
    private var promos = [Promo]()
    private var isLoading = false

    private let networkService: PromoNetworkServiceInput

    init(networkService: PromoNetworkServiceInput) {
        self.networkService = networkService
    }

    // MARK: - Conforming of the PromoInteractorInput

    var canFetchNextPage: Bool {
        hasNext
    }

    func fetchPromos() {
        guard !isLoading else { return }

        networkService.fetchPromos { [weak self] response in
            // нужно договорится на каком потоке возвращаем итоги и кто этим занимается
            // по мне, инкапсулировать всю эту логику в интеракторе удобнее,
            // так остальные слои не будут знать ничего, кроме main thread
            DispatchQueue.main.async {
                switch response {
                case let .success(promosResponse):
                    self?.hasNext = promosResponse.hasNext
                    self?.promos.append(contentsOf: promosResponse.items)

                    self?.isLoading = false
                    self?.output?.didFetchPromos(self?.promos ?? [])

                case let .failure(error):
                    self?.isLoading = false
                    self?.output?.fetchingDidFail(with: error)
                }
            }
        }
    }
}
