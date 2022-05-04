import UIKit

struct PromoDetailsViewModelBuilder {
    // предложение выносить работу билдеров из main queue
    private let workingQueue = DispatchQueue(
        label: "com.mz.mvp-data-driven-ui-demo.PromoDetailsViewModelBuilder",
        attributes: .concurrent
    )

    func makeViewModel(
        with promo: Promo,
        state: PromoButton.ViewModel,
        _ completion: @escaping (PromoDetailsViewController.ViewModel) -> Void
    ) {
        workingQueue.async {
            let model = PromoDetailsViewController.ViewModel(
                screenTitle: "Подробности",
                image: UIImage(contentsOfFile: promo.imageURL.path),
                title: promo.title,
                issueDate: promo.issueDate,
                promoDescription: promo.promoDescription,
                buttonViewModel: state
            )

            DispatchQueue.main.async {
                completion(model)
            }
        }
    }
}
