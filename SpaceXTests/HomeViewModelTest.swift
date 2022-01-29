import XCTest
import RxSwift
import RxTest

@testable import SpaceX

class HomeViewModelTest: XCTestCase {
    
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

        let sectionModelObs = scheduler.createObserver([HomeSectionModel].self)

        let rockets: Rockets = [
            Rocket.initRocketWith(title: "Rocket 1", dateUTC: "2020-03-24T22:30:00.000Z"),
            Rocket.initRocketWith(title: "Rocket 2", dateUTC: "2020-03-24T22:30:00.000Z"),
            Rocket.initRocketWith(title: "Rocket 3", dateUTC: "2020-03-24T22:30:00.000Z")
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
        
        let error: NSError = NSError(domain: "", code: 0, userInfo: [:])
        rocketAPIMock.stubReturnRocketsError(error)
        viewModel.getRockets()
        
        XCTAssertEqual(rocketAPIMock.fetchRocketAPICalled, 0)
        XCTAssertEqual(rocketAPIMock.fetchRocketAPIErrorCalled, 1)
    }
    
    func testGetRocketAPIUpcoming_ExpectedMatchMock() {
        
        let rocketAPIMock = RocketAPIMock()
        let viewModel = generateViewModel(rocketAPIMock)

        let sectionModelObs = scheduler.createObserver([HomeSectionModel].self)

        let upcomingRocket = Rocket.initRocketWith(title: "Rocket 1", upcoming: true, dateUTC: "2020-03-24T22:30:00.000Z")

        let rockets: Rockets = [
            upcomingRocket,
            Rocket.initRocketWith(title: "Rocket 2", dateUTC: "2020-03-24T22:30:00.000Z"),
            Rocket.initRocketWith(title: "Rocket 3", dateUTC: "2020-03-24T22:30:00.000Z")
        ]
        
        rocketAPIMock.stubReturnRockets(rockets)
        viewModel.setIsUpcoming(true)
        viewModel.getRockets()

        viewModel.sectionModels
            .drive(sectionModelObs)
            .disposed(by: disposeBag)
        scheduler.start()

        let expectedSectionModel: [HomeSectionModel] = [.rocketSection(title: "Rockets", items: [.rocketItem(rocket: upcomingRocket)])]
        
        XCTAssertEqual(rocketAPIMock.fetchRocketAPICalled, 1)
        XCTAssertEqual(rocketAPIMock.fetchRocketAPIErrorCalled, 0)
        XCTAssertEqual(sectionModelObs.events, [.next(0, expectedSectionModel)])
    }
    
    func testGetRocketAPIYears_ExpectedMatchMock() {
        
        let rocketAPIMock = RocketAPIMock()
        let viewModel = generateViewModel(rocketAPIMock)

        let sectionModelObs = scheduler.createObserver([HomeSectionModel].self)

        let twentyTwentyTwo1 = Rocket.initRocketWith(title: "Rocket 1", upcoming: true, dateUTC: "2023-03-24T22:30:00.000Z")
        let twentyTwentyTwo2 = Rocket.initRocketWith(title: "Rocket 3", upcoming: true, dateUTC: "2023-03-24T22:30:00.000Z")

        let rockets: Rockets = [
            twentyTwentyTwo1,
            Rocket.initRocketWith(title: "Rocket 2"),
            twentyTwentyTwo2
        ]
        
        rocketAPIMock.stubReturnRockets(rockets)
        viewModel.setSelectedYear(2) // 2022
        viewModel.getRockets()

        viewModel.sectionModels
            .drive(sectionModelObs)
            .disposed(by: disposeBag)
        scheduler.start()

        let expectedSectionModel: [HomeSectionModel] = [.rocketSection(title: "Rockets", items: [
            .rocketItem(rocket: twentyTwentyTwo1),
            .rocketItem(rocket: twentyTwentyTwo2)
        ])]
        
        XCTAssertEqual(rocketAPIMock.fetchRocketAPICalled, 1)
        XCTAssertEqual(rocketAPIMock.fetchRocketAPIErrorCalled, 0)
        XCTAssertEqual(sectionModelObs.events, [.next(0, expectedSectionModel)])
    }
}
