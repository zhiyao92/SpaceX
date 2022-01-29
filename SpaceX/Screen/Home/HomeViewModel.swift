import Foundation
import RxSwift
import RxDataSources
import RxCocoa

enum Years: Int, CaseIterable {
    case twentyTwenty = 2020
    case twentyTwentyOne = 2021
    case twentyTwentyTwo = 2022
}

class HomeViewModel {

    private let years = Years.allCases
    private var selectedYears: Years = .twentyTwenty
    private var isUpcoming = false
    
    private var _sectionModels: BehaviorSubject<[HomeSectionModel]> = BehaviorSubject(value: [])
    private var _error: BehaviorSubject<Error?> = BehaviorSubject(value: nil)

    var sectionModels: SharedSequence<DriverSharingStrategy, [HomeSectionModel]> {
        return _sectionModels.asDriver(onErrorJustReturn: [])
    }
    
    var error: SharedSequence<DriverSharingStrategy, Error?> {
        return _error.asDriver(onErrorJustReturn: nil)
    }
    
    private let rocketAPI: RocketAPIProtocol

    let disposeBag = DisposeBag()

    init(rocketAPI: RocketAPIProtocol) {
        self.rocketAPI = rocketAPI
    }
    
    func getYears() -> [Years] {
        return years
    }
    
    func getRockets() {
        rocketAPI.fetchRockets()
            .subscribe { [weak self] rockets in
                let filteredRockets = rockets.filter( { Int($0.dateUTC.toISODate()?.toString(withFormat: "yyyy") ?? "") ?? 0 >= self?.selectedYears.rawValue ?? 0 })
                
                self?.configureSection(rockets: filteredRockets)
            } onError: { [weak self] error in
                self?._error.onNext(error)
            }.disposed(by: disposeBag)
    }
    
    func configureSection(rockets: Rockets) {
        var homeSectionItems: [HomeSectionItem] = []
        
        if self.isUpcoming {
            homeSectionItems = rockets.filter { $0.upcoming }.map { .rocketItem(rocket: $0) }
        } else {
            homeSectionItems = rockets.map { .rocketItem(rocket: $0) }
        }
        
        let homeSectionModel: [HomeSectionModel] = [
            .rocketSection(title: "Rockets", items: homeSectionItems)
        ]
        
        _sectionModels.onNext(homeSectionModel)
    }
    
    func setSelectedYear(_ row: Int) {
        self.selectedYears = years[row]
    }
    
    func setIsUpcoming(_ isUpComing: Bool) {
        self.isUpcoming = isUpComing
    }
}

enum HomeSectionModel: Equatable {
    case rocketSection(title: String, items: [HomeSectionItem])
    
    static func == (lhs: HomeSectionModel, rhs: HomeSectionModel) -> Bool {
        switch (lhs, rhs) {
        case (let .rocketSection(lhsTitle, lhsItems), let .rocketSection(rhsTitle, rhsItems)):
            return (lhsTitle, lhsItems) == (rhsTitle, rhsItems)
        }
    }
}

enum HomeSectionItem: Equatable {
    case rocketItem(rocket: Rocket)
    
    static func == (lhs: HomeSectionItem, rhs: HomeSectionItem) -> Bool {
        switch (lhs, rhs) {
        case (let .rocketItem(lhsRocket), let .rocketItem(rhsRocket)):
            return lhsRocket.name == rhsRocket.name
        }
    }
}

extension HomeSectionModel: SectionModelType {
    typealias Item = HomeSectionItem
    
    var items: [HomeSectionItem] {
        switch  self {
        case .rocketSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: HomeSectionModel, items: [Item]) {
        switch original {
        case let .rocketSection(title: title, items: _):
            self = .rocketSection(title: title, items: items)
        }
    }
}

extension HomeSectionModel {
    var title: String {
        switch self {
        case .rocketSection(title: let title, items: _):
            return title
        }
    }
}
