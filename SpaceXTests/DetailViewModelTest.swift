import XCTest
import RxSwift
import RxTest

@testable import SpaceX

class DetailViewModelTest: XCTestCase {
    
    var scheduler: TestScheduler!

    let disposeBag: DisposeBag = DisposeBag()
    
    private func generateViewModel(_ rocketMockAPI: RocketAPIProtocol = RocketAPIMock()) -> DetailViewModel {
        self.scheduler = TestScheduler(initialClock: 0)
        return DetailViewModel(rocketAPI: rocketMockAPI)
    }
    
    func testGetRocketAPI_ExpectedMatchMock() {
        
        let rocketAPIMock = RocketAPIMock()
        let viewModel = generateViewModel(rocketAPIMock)

        let rocketDetailObs = scheduler.createObserver(RocketDetail?.self)

        let expectedRocketDetail = RocketDetail.initWith(id: "123")

        rocketAPIMock.stubReturnRocketDetail(expectedRocketDetail)
        viewModel.getRocketDetails(id: "123")

        viewModel.dataSource
            .drive(rocketDetailObs)
            .disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssertEqual(rocketAPIMock.fetchRocketDetailAPICalled, 1)
        XCTAssertEqual(rocketAPIMock.fetchRocketDetailAPIErrorCalled, 0)
        XCTAssertEqual(rocketDetailObs.events, [.next(0, expectedRocketDetail)])
    }
    
    func testGetRocketAPIError_ExpectedMatchMock() {
        
        let rocketAPIMock = RocketAPIMock()
        let viewModel = generateViewModel(rocketAPIMock)

        let error: NSError = NSError(domain: "", code: 0, userInfo: [:])
        rocketAPIMock.stubReturnRocketDetailError(error)
        viewModel.getRocketDetails(id: "")
        
        XCTAssertEqual(rocketAPIMock.fetchRocketDetailAPICalled, 0)
        XCTAssertEqual(rocketAPIMock.fetchRocketDetailAPIErrorCalled, 1)
    }
}
