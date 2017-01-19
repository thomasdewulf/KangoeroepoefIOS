import UIKit

class DrankDetailController : UITableViewController {
    var drank: Drank!
    var user : ApplicationUser!
    @IBOutlet weak var naamCell: UITableViewCell!
    @IBOutlet weak var alcoholCell: UITableViewCell!
    @IBOutlet weak var prijsCell: UITableViewCell!
    @IBOutlet weak var aantalCell: UITableViewCell!
    
    
    
    override func viewDidLoad() {
        let aantalGedronken = RealmService.realm.objects(Orderline.self).filter({$0.drank == self.drank && $0.orderedFor == self.user}).count
        title = drank.naam
        naamCell.detailTextLabel!.text = drank.naam
        alcoholCell.detailTextLabel!.text = drank.alcoholisch ? "Ja" : "Nee"
        prijsCell.detailTextLabel!.text = "€ \(drank.prijs.description)"
        aantalCell.detailTextLabel!.text = aantalGedronken.description
        
    }
}
