import XCTest
@testable import mvp_data_driven_ui_demo

class PromoPresenterTests: XCTestCase {
    var sut: PromoPresenter!
    var testView: TestPromoViewInput!
    var testCollectionAdapter: TestPromoCollectionAdapter!
    var testNetworkService: TestPromoNetworkService!

    override func setUp() {
        super.setUp()

        testView = TestPromoViewInput()
        testCollectionAdapter = TestPromoCollectionAdapter()

        testNetworkService = TestPromoNetworkService()
        let interactor = PromoInteractor(networkService: testNetworkService)

        sut = PromoPresenter(
            interactor: interactor,
            view: testView,
            collectionAdapter: testCollectionAdapter,
            output: nil
        )

        interactor.output = sut
    }

    override func tearDown() {
        sut = nil
        testView = nil
        testCollectionAdapter = nil
        testNetworkService = nil

        super.tearDown()
    }

    func testSuccessFetching() {
        let viewExp = expectation(description: "view")
        testView.expectation = viewExp

        let adapterExp = expectation(description: "adapter")
        testCollectionAdapter.expectation = adapterExp

        testNetworkService.isSuccessFetching = true
        sut.viewDidLoad()

        wait(for: [viewExp, adapterExp], timeout: 0.5)
        XCTAssertTrue(testView.wasRenderMethodCalledCorrectly && testCollectionAdapter.wasRenderMethodCalledCorrectly)
    }

    func testFailureFetching() {
        let viewExp = expectation(description: "view")
        testView.expectation = viewExp

        testNetworkService.isSuccessFetching = false
        sut.viewDidLoad()

        waitForExpectations(timeout: 0.5)
        XCTAssertTrue(testView.wasRenderMethodCalledCorrectly)
    }
}
