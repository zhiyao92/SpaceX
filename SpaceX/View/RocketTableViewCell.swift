import UIKit

class RocketTableViewCell: UITableViewCell, ReuseIdentifier {

    @IBOutlet private weak var rocketTitleLabel: UILabel!
    @IBOutlet private weak var rocketDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rocketTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        rocketDescriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    func configureRocket(_ rocket: Rocket) {
        rocketTitleLabel.text = rocket.name
        rocketDescriptionLabel.text = rocket.details
    }
}
