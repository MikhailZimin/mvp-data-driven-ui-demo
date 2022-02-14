import Foundation

protocol PromoDetailsNetworkServiceInput {
    func fetchPromoState(_ completion: @escaping (Result<Promo.State, Error>) -> Void)
    func acceptPromo(_ completion: @escaping (Result<Void, Error>) -> Void)
}

struct PromoDetailsNetworkService: PromoDetailsNetworkServiceInput {
    // MARK: - Conforming of the PromoDetailsNetworkServiceInput

    func fetchPromoState(_ completion: @escaping (Result<Promo.State, Error>) -> Void) {
        // mock fetching...

        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
            let random = Int.random(in: 0..<3)

            switch random {
            case 0:
                completion(.success(.pending))
            case 1:
                completion(.success(.active))
            case 2:
                completion(.failure(NSError()))
            default:
                completion(.success(.pending))
            }
        }
    }

    func acceptPromo(_ completion: @escaping (Result<Void, Error>) -> Void) {
        // mock fetching...

        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
            let random = Int.random(in: 0..<2)

            switch random {
            case 0:
                completion(.success(()))
            case 1:
                completion(.failure(NSError()))
            default:
                completion(.success(()))
            }
        }
    }
}
