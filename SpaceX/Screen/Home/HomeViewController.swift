import UIKit
import RxDataSources
import RxSwift

class HomeViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var filterBarButtonItem: UIBarButtonItem!

    var viewModel: HomeViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
        configureTableView()
    }
    
    private func configureView() {
        self.title = "SpaceX"
        filterBarButtonItem.image = UIImage(systemName: "slider.horizontal.3")
        statusSegmentedControl.setTitle("Completed", forSegmentAt: 0)
        statusSegmentedControl.setTitle("Upcoming", forSegmentAt: 1)
    }
    
    private func configureViewModel() {
        let rocketAPI = RocketAPI()
        viewModel = HomeViewModel(rocketAPI: rocketAPI)
                
        viewModel?.getRockets()

        bindViewModel()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: RocketTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: RocketTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func presentFilterAlert() {
        let alert = UIAlertController(title: "Pick Years", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 150))
        alert.view.addSubview(pickerFrame)
        
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.viewModel?.getRockets()
        }))
        self.present(alert,animated: true, completion: nil )
    }
    
    @IBAction func selectFilter(_ sender: UIBarButtonItem) {
        presentFilterAlert()
    }
    
    private func bindViewModel() {
        let dataSoure = HomeViewController.dataSource()
        
        viewModel?.sectionModels
            .drive(tableView.rx.items(dataSource: dataSoure))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HomeSectionItem.self)
            .asDriver()
            .drive(onNext: { [weak self] model in
                switch model {
                case .rocketItem(rocket: let rocket):
                    self?.presentRocketDetail(rocket.rocket)
                }
            }).disposed(by: disposeBag)
        
        viewModel?.error
            .drive(onNext: { [weak self] error in
                guard let error = error else { return }
                self?.presentErrorAlert(description: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func pressSegmentControl(_ sender: UISegmentedControl) {
        viewModel?.setIsUpcoming(sender.selectedSegmentIndex == 1)
        viewModel?.getRockets()
    }
    
    private func presentRocketDetail(_ id: String) {
        guard let detailViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        else { fatalError("Unable to Instantiate DetailViewController") }

        detailViewController.loadViewIfNeeded()
        detailViewController.configureViewModel(id)
        
        let navigationController = UINavigationController(rootViewController: detailViewController)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
}

extension HomeViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<HomeSectionModel> {
        return RxTableViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell: { dataSource, tableView, indexPath, _ in
                switch dataSource[indexPath] {
                case let .rocketItem(rocket: rocket):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: RocketTableViewCell.reuseIdentifier, for: indexPath) as? RocketTableViewCell else { fatalError("RocketTableViewCell not found") }
                    cell.selectionStyle = .none
                    cell.configureRocket(rocket)
                    return cell
                }
            }, titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
            })
    }
}

// MARK: - UIPickerViewDelegate
extension HomeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel?.setSelectedYear(row)
    }
}

// MARK: - UIPickerViewDataSource
extension HomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.getYears().count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let years = viewModel?.getYears() ?? []
        return years[row].rawValue.description
    }
}
