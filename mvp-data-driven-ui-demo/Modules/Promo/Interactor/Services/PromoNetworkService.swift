import Foundation

// в идеале, получать тут Decodable DTO и отдавать их в интерактор
// а далее DTOParser конвертирует в нужные Entity
// в DTOParser прописываются сценарии конвертации, обрабатываются ошибочные ситуации, опциональные и не опциональные поля и тп

protocol PromoNetworkServiceInput {
    func fetchPromos(_ completion: @escaping (Result<[Promo], Error>) -> Void)
}

struct PromoNetworkService: PromoNetworkServiceInput {
    // MARK: - Conforming of the PromoNetworkServiceInput

    func fetchPromos(_ completion: @escaping (Result<[Promo], Error>) -> Void) {
        // mock fetching...

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

        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
            completion(.success(promos))
        }
    }
}