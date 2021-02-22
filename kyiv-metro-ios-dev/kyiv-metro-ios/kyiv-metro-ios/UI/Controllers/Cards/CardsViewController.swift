
import UIKit

struct CardModel {
    var cardNumber: String
    var isMain: Bool
}

class CardsViewController: BaseViewController {
    
    @IBOutlet weak var cardsTableView: UITableView!
    
    override class var storyboard: Storyboard {
        return .card
    }
    
    var cardsModel: [CardModel] = [CardModel(cardNumber: "4214124222222222", isMain: true), CardModel(cardNumber: "5168312002442333", isMain: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsTableView.register(cellType: CardCell.self)
        self.cardsTableView.delegate = self
        self.cardsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = "Профіль"
        navigationController?.title = ""
    }
    
    // MARK: - Actions
    @IBAction func addButtonPressed() {
        let vc = AddCardViewController.instantiate()
        vc.isFromRegistration = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate + UITableViewDataSourse

extension CardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(cellType: CardCell.self)
        cell.configure(with: cardsModel[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension CardsViewController: CardCellDelegate {
    func cardDeleted(index: Int) {
        cardsModel.remove(at: index)
        cardsTableView.reloadData()
    }
}
