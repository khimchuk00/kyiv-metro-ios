
import UIKit

class DefaultCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    
    func configure(rowModel: ProfileViewController.TableViewSections.TableViewRow) {
        cellTitle.text = rowModel.cellTitle
        cellTitle.textColor = rowModel.cellTextColor
    }
}
