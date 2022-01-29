import Foundation
import RxSwift

protocol RocketAPIProtocol {
    func fetchRockets(from year: Int) -> Observable<Rockets>
    func fetchRocketDetail(id: String) -> Observable<RocketDetail>
}

class RocketAPI: RocketAPIProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchRockets(from year: Int) -> Observable<Rockets> {
        return Observable.create { [weak self] observer -> Disposable in
            self?.performAPIRequest("launches") { result in
                switch result {
                case .success(let response):
                    
                    guard let response = try? response.decode(to: Rockets.self)
                    else {
                        observer.onError(APIError.decodingFailure)
                        return
                    }
                    
                    let filteredRockets = response.body.filter( { Int($0.dateUTC.toISODate()?.toString(withFormat: "yyyy") ?? "") ?? 0 >= year })
                    observer.onNext(filteredRockets)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchRocketDetail(id: String) -> Observable<RocketDetail> {
        let path = "rockets/\(id)"
        return Observable.create { [weak self] observer -> Disposable in
            self?.performAPIRequest(path) { result in
                switch result {
                case .success(let response):
                    
                    guard let response = try? response.decode(to: RocketDetail.self)
                    else {
                        observer.onError(APIError.decodingFailure)
                        return
                    }
                    
                    observer.onNext(response.body)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    private func performAPIRequest(_ path: String, _ completion: @escaping APIClientCompletion) {
        let request = APIRequest(method: .get, path: path)
        apiClient.perform(request, completion)
    }
}
