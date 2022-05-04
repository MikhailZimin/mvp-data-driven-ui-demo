import UIKit

struct PromoViewModelBuilder {
    // предложение выносить работу билдеров из main queue
    private let workingQueue = DispatchQueue(
        label: "com.mz.mvp-data-driven-ui-demo.PromoViewModelBuilderQueue",
        attributes: .concurrent
    )

    func makeViewModel(isFetchingFailed: Bool, _ completion: @escaping (PromoViewController.ViewModel) -> Void) {
        workingQueue.async {
            let model = PromoViewController.ViewModel(
                title: "Promo",
                backgroundColor: isFetchingFailed ? .systemRed : .darkGray,
                isCollectionHidden: isFetchingFailed
            )

            DispatchQueue.main.async {
                completion(model)
            }
        }
    }

    func makeAdapterViewModel(
        from promos: [Promo],
        commandAction: @escaping (Promo) -> Void,
        _ completion: @escaping (PromoCollectionAdapter.ViewModel) -> Void
    ) {
        workingQueue.async {
            let items = promos.map { promo in
                PromoCellContentView.ViewModel(
                    imageURL: promo.imageURL,
                    title: promo.title,
                    action: Command { commandAction(promo) }
                )
            }

            DispatchQueue.main.async {
                completion(PromoCollectionAdapter.ViewModel(items: items))
            }
        }
    }
}
