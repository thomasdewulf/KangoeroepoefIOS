import UIKit

class DrankDetailController : UITableViewController {
    var drank: Drank!
    @IBOutlet weak var naamCell: UITableViewCell!
    @IBOutlet weak var alcoholCell: UITableViewCell!
    @IBOutlet weak var prijsCell: UITableViewCell!
    @IBOutlet weak var aantalCell: UITableViewCell!
    
    override func viewDidLoad() {
        title = drank.naam
        naamCell.detailTextLabel!.text = drank.naam
        alcoholCell.detailTextLabel!.text = drank.alcoholisch ? "Ja" : "Nee"
        prijsCell.detailTextLabel!.text = "€ \(drank.prijs.description)"
        aantalCell.detailTextLabel!.text = "0"
        
    }
}
