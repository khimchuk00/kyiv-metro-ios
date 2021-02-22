import UIKit

protocol CardCellDelegate: class {
    func cardDeleted(index: Int)
}

class CardCell: UITableViewCell {
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardTypeImage: UIImageView!
    
    var index: Int = 1
    weak var delegate: CardCellDelegate?

    func configure(with model: CardModel, index: Int) {
        checkImage.isHidden = !model.isMain
        var modifiedCard = model.cardNumber
        modifiedCard.removeFirst(12)
        modifiedCard = "****-" + modifiedCard
        let attrTitle = NSMutableAttributedString(string: modifiedCard, attributes: [
            .foregroundColor: Theme.Colors.themeDarkGray,
            .font: Theme.Fonts.themeFont(size: 17, mode: .semibold)
        ])
        
        if model.isMain {
            attrTitle.append(NSAttributedString(string: " Основна", attributes: [
                .foregroundColor: Theme.Colors.themeGreen,
                .font: Theme.Fonts.themeFont(size: 17, mode: .semibold)
            ]))
        }
        cardNumberLabel.attributedText = attrTitle
        
        if model.cardNumber.first == "4" {
            cardTypeImage.image = UIImage(named: "")
        } else {
            cardTypeImage.image = UIImage(named: "mastercard")
        }
    }
    
    // MARK: - Actions
    @IBAction func deleteButtonPressed() {
        delegate?.cardDeleted(index: index)
    }
}
