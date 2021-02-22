
import UIKit

class ButtonCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLeadingConstraint: NSLayoutConstraint!
    
    func configure(rowModel: ProfileViewController.TableViewSections.TableViewRow) {
        cellTitle.text = rowModel.cellTitle
        cellImage.image = rowModel.cellImage
        cellTitle.textColor = rowModel.cellTextColor
        
        if rowModel.cellImage != nil {
            cellHeightConstraint.constant = 24
            cellImage.isHidden = false
            titleLeadingConstraint.constant = 10
        } else {
            cellHeightConstraint.constant = 0
            cellImage.isHidden = true
            titleLeadingConstraint.constant = 0
        }
    }
}
