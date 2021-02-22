
import UIKit

protocol SwitchCellDelegate: class {
    func stateChanged (isOn: Bool)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    weak var cellDelegate: SwitchCellDelegate?
    
    func configure(rowModel: ProfileViewController.TableViewSections.TableViewRow, isOn: Bool) {
        cellTitle.text = rowModel.cellTitle
        cellTitle.textColor = rowModel.cellTextColor
        switcher.isOn = isOn
    }

    // MARK: - Actions
    
    @IBAction func switcherChanged() {
        cellDelegate?.stateChanged(isOn: switcher.isOn)
    }
    
}
