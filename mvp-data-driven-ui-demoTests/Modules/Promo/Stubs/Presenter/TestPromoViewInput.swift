import UIKit
import XCTest
@testable import mvp_data_driven_ui_demo

final class TestPromoViewInput: PromoViewInput {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var renderCallCount = 0

    var expectation: XCTestExpectation? {
        didSet {
            renderCallCount = 0
        }
    }

    var wasRenderMethodCalledCorrectly = false
    func render(model: DataDrivenModel) {
        renderCallCount += 1

        guard renderCallCount == 2 else { return }

        wasRenderMethodCalledCorrectly = model is PromoViewController.ViewModel && Thread.isMainThread
        expectation?.fulfill()
    }
}
