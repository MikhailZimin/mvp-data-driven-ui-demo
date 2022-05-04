import UIKit
import XCTest
@testable import mvp_data_driven_ui_demo

final class TestPromoCollectionAdapter: DataDrivable {
    var expectation: XCTestExpectation?

    var wasRenderMethodCalledCorrectly = false
    func render(model: PromoCollectionAdapter.ViewModel) {
        wasRenderMethodCalledCorrectly = Thread.isMainThread
        expectation?.fulfill()
    }
}
