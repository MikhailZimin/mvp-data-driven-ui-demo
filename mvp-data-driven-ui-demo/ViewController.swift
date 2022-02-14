//
//  ViewController.swift
//  mvp-data-driven-ui-demo
//
//  Created by Mikhail Zimin on 14.02.2022.
//

import UIKit

// абстрактный viewController, с которого мы попадаем на список промо-акций

class ViewController: UIViewController {
    var promoCoordinator: PromoCoordinator?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let navigationController = UINavigationController()
        promoCoordinator = PromoCoordinator(navigationController: navigationController)
        promoCoordinator?.start()
        present(navigationController, animated: true)
    }
}

