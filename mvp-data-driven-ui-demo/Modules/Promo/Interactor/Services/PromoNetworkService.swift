import Foundation

struct PromoItemsResponse {
    let items: [Promo]
    let hasNext: Bool
}

protocol PromoNetworkServiceInput {
    func fetchPromos(_ completion: @escaping (Result<PromoItemsResponse, Error>) -> Void)
}

final class PromoNetworkService: PromoNetworkServiceInput {
    private var page = 0

    private let pageSize = 5
    private let pageLimit = 10

    // MARK: - Conforming of the PromoNetworkServiceInput

    func fetchPromos(_ completion: @escaping (Result<PromoItemsResponse, Error>) -> Void) {
        // mock fetching...
        if page > 0 || Bool.random() {
            guard let imageURL = Bundle.main.url(forResource: "promo", withExtension: "jpg") else { return }

            let loremText = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    """

            page += 1

            let promos = (1..<pageSize).map {
                Promo(
                    id: UUID().uuidString,
                    imageURL: imageURL,
                    title: "Promo \($0 * page)",
                    issueDate: "C \($0).03.2022",
                    promoDescription: loremText
                )
            }
            let response = PromoItemsResponse(items: promos, hasNext: page < pageLimit)

            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
                completion(.success(response))
            }
        } else {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
                completion(.failure(LoadingError.unowned))
            }
        }
    }

    private enum LoadingError: Error {
        case unowned
    }
}
