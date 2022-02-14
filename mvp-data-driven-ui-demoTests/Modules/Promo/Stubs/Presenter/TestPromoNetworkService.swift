import Foundation
@testable import mvp_data_driven_ui_demo

struct TestPromoNetworkService: PromoNetworkServiceInput {
    var isSuccessFetching = true

    // MARK: - Conforming of the PromoNetworkServiceInput

    func fetchPromos(_ completion: @escaping (Result<[Promo], Error>) -> Void) {
        if isSuccessFetching {
            guard let imageURL = Bundle.main.url(forResource: "promo", withExtension: "jpg") else { return }

            let loremText = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
"""

            let promos = (1..<20).map {
                Promo(
                    id: UUID().uuidString,
                    imageURL: imageURL,
                    title: "Promo \($0)",
                    issueDate: "C \($0).03.2022",
                    promoDescription: loremText
                )
            }

            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {
                completion(.success(promos))
            }
        } else {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {
                completion(.failure(NSError()))
            }
        }
    }
}
