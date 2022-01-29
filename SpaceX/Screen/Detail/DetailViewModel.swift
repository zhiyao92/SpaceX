import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
    
    private var _dataSource: BehaviorSubject<RocketDetail?> = BehaviorSubject(value: nil)
    private var _error: BehaviorSubject<Error?> = BehaviorSubject(value: nil)

    var dataSource: SharedSequence<DriverSharingStrategy, RocketDetail?> {
        return _dataSource.asDriver(onErrorJustReturn: nil)
    }
    
    var error: SharedSequence<DriverSharingStrategy, Error?> {
        return _error.asDriver(onErrorJustReturn: nil)
    }

    private let rocketAPI: RocketAPIProtocol
    
    let disposeBag = DisposeBag()
    
    init(rocketAPI: RocketAPIProtocol) {
        self.rocketAPI = rocketAPI
    }
    
    func getRocketDetails(id: String) {
        rocketAPI.fetchRocketDetail(id: id)
            .subscribe { [weak self] rocketDetail in
                self?._dataSource.onNext(rocketDetail)
            } onError: { [weak self] error in
                self?._error.onNext(error)
            }.disposed(by: disposeBag)
    }
}
