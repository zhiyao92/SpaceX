import XCTest
import RxSwift
import RxTest

@testable import SpaceX

class HomeViewModelTest: XCTestCase {
    
    var expectation: XCTestExpectation!
    var scheduler: TestScheduler!

    let disposeBag: DisposeBag = DisposeBag()
    
    private func generateViewModel(_ rocketMockAPI: RocketAPIProtocol = RocketAPIMock()) -> HomeViewModel {
        self.scheduler = TestScheduler(initialClock: 0)
        return HomeViewModel(rocketAPI: rocketMockAPI)
    }

    func testGetYears_ExpectedCountThree() {
        let viewModel = generateViewModel()
        
        XCTAssertEqual(viewModel.getYears().count, 3)
    }
    
    func testGetRocketAPI_ExpectedMatchMock() {
        
        let rocketAPIMock = RocketAPIMock()
        let viewModel = generateViewModel(rocketAPIMock)
        expectation = XCTestExpectation(description: "getRocket API")

        let sectionModelObs = scheduler.createObserver([HomeSectionModel].self)

        let rockets: Rockets = [
            Rocket.initRocketWith(title: "Rocket 1"),
            Rocket.initRocketWith(title: "Rocket 2"),
            Rocket.initRocketWith(title: "Rocket 3")
        ]
        
        rocketAPIMock.stubReturnRockets(rockets)
        viewModel.getRockets()

        viewModel.sectionModels
            .drive(sectionModelObs)
            .disposed(by: disposeBag)
        scheduler.start()

        let expectedSectionModel: [HomeSectionModel] = [.rocketSection(title: "Rockets", items:  rockets.map { .rocketItem(rocket: $0) })]
        
        XCTAssertEqual(rocketAPIMock.fetchRocketAPICalled, 1)
        XCTAssertEqual(rocketAPIMock.fetchRocketAPIErrorCalled, 0)
        XCTAssertEqual(sectionModelObs.events, [.next(0, expectedSectionModel)])
    }
    
    func testGetRocketAPIError_ExpectedMatchMock() {
        
        let rocketAPIMock = RocketAPIMock()
        let viewModel = generateViewModel(rocketAPIMock)
        expectation = XCTestExpectation(description: "getRocket API error")
        
        let error: NSError = NSError(domain: "", code: 0, userInfo: [:])
        rocketAPIMock.stubReturnRocketsError(error)
        viewModel.getRockets()
        
        XCTAssertEqual(rocketAPIMock.fetchRocketAPICalled, 0)
        XCTAssertEqual(rocketAPIMock.fetchRocketAPIErrorCalled, 1)
    }
}
