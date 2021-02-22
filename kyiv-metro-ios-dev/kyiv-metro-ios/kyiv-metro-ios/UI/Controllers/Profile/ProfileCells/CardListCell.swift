
import UIKit

class CardListCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellCardNumber: UILabel!
    @IBOutlet weak var cardTypeImage: UIImageView!
    
    func configure(title: String, cardNumber: String) {
        cellTitle.text = title
        
        var modifiedCard = cardNumber
        modifiedCard.removeFirst(12)
        modifiedCard = "****-" + modifiedCard
        
        cellCardNumber.text = modifiedCard
        
        if cardNumber.first == "4" {
            cardTypeImage.image = UIImage(named: "")
        } else {
            cardTypeImage.image = UIImage(named: "mastercard")
        }
        
    }
}
