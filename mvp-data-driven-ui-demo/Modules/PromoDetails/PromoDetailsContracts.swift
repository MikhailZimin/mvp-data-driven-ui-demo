protocol PromoDetailsInteractorInput {
    var promo: Promo { get }

    func fetchPromoState()
    func acceptPromo()
}

protocol PromoDetailsInteractorOutput: AnyObject {
    func didFetchPromoState(_ state: Promo.State)
    func fetchingPromoStateDidFail(with error: Error)
    func didAcceptPromo()
    func acceptingDidFail(with error: Error)
}

protocol PromoDetailsViewInput: DataDrivable {

}

protocol PromoDetailsViewOutput {
    func viewDidLoad()
}
