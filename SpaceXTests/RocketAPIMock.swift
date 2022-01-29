import Foundation
import RxSwift

@testable import SpaceX

class RocketAPIMock: RocketAPI {

    var fetchRocketAPICalled = 0
    var fetchRocketAPIErrorCalled = 0

    var fetchRocketDetailAPICalled = 0
    var fetchRocketDetailAPIErrorCalled = 0

    private var rockets: Rockets = []
    private var rocketDetail: RocketDetail? = nil
    
    private var rocketsError: Error?
    private var rocketDetailError: Error?

    func stubReturnRockets(_ rockets: Rockets) {
        self.rockets = rockets
    }
    
    func stubReturnRocketsError(_ apiError: Error) {
        self.rocketsError = apiError
    }
    
    func stubReturnRocketDetail(_ rocketDetail: RocketDetail) {
        self.rocketDetail = rocketDetail
    }
    
    func stubReturnRocketDetailError(_ apiError: Error) {
        self.rocketDetailError = apiError
    }
    
    override func fetchRocketDetail(id: String) -> Observable<RocketDetail> {
        if let apiError = rocketDetailError {
            fetchRocketDetailAPIErrorCalled += 1
            return Observable.error(apiError)
        } else {
            fetchRocketDetailAPICalled += 1
            return Observable.just(rocketDetail!)
        }
    }
    
    override func fetchRockets(from year: Int) -> Observable<Rockets> {
        if let apiError = rocketsError {
            fetchRocketAPIErrorCalled += 1
            return Observable.error(apiError)
        } else {
            fetchRocketAPICalled += 1
            return Observable.just(rockets)
        }
    }
}
