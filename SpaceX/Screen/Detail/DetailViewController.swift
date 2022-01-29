import UIKit
import RxSwift
import RxCocoa
import SafariServices

class DetailViewController: BaseViewController {

    @IBOutlet private weak var rocketImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nameValueLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var descriptionValueLabel: UILabel!
    @IBOutlet private weak var wikipediaButton: UIButton!
    
    var viewModel: DetailViewModel?
    
    private var wikipediaUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureViewModel(_ id: String) {
        let rocketAPI = RocketAPI()
        viewModel = DetailViewModel(rocketAPI: rocketAPI)
        
        viewModel?.getRocketDetails(id: id)
        bindViewModel()
    }
    
    private func configureView() {
        _ = [nameLabel, descriptionLabel].map {
            $0.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
        _ = [nameValueLabel, descriptionValueLabel].map {
            $0?.font = UIFont.systemFont(ofSize: 15)
            $0?.numberOfLines = 0
        }
        
        nameLabel.text = "Rocket name"
        descriptionLabel.text = "Rocket description"
        rocketImageView.contentMode = .scaleToFill
        wikipediaButton.setTitle("Open link on Wikipedia", for: .normal)
    }
    
    private func bindViewModel() {
        viewModel?.dataSource
            .drive(onNext: { [weak self] rocketDetail in
                guard let rocketDetail = rocketDetail else { return }
                
                if let image = rocketDetail.flickrImages.first, let imageUrl = URL(string: image) {
                    self?.rocketImageView.load(url: imageUrl)
                }
                
                self?.wikipediaUrl = URL(string: rocketDetail.wikipedia)
                self?.title = rocketDetail.name
                self?.nameValueLabel.text = rocketDetail.name
                self?.descriptionValueLabel.text = rocketDetail.rocketDetailDescription
            }).disposed(by: disposeBag)
        
        viewModel?.error
            .drive(onNext: { [weak self] error in
                guard let error = error else { return }

                self?.presentErrorAlert(description: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    // The proper way is to send the event (tap) from ViewController to ViewModel
    // And data from ViewModel to ViewController
    @IBAction func pressWikipediaButton() {
        guard let wikipediaUrl = wikipediaUrl else { return }

        let sfSafari = SFSafariViewController(url: wikipediaUrl)
        self.navigationController?.pushViewController(sfSafari, animated: true)
    }
}
