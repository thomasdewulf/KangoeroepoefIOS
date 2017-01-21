import UIKit

class DrankDetailController : UITableViewController {
    //vars
    var drank: Drank!
    var user : ApplicationUser!
    
    //realm
    let realm = RealmService()
    //Outlets
    @IBOutlet weak var naamCell: UITableViewCell!
    @IBOutlet weak var alcoholCell: UITableViewCell!
    @IBOutlet weak var prijsCell: UITableViewCell!
    @IBOutlet weak var aantalCell: UITableViewCell!
    
    
    
    override func viewDidLoad() {
        
        let aantalGedronken = realm.realm.objects(Orderline.self).filter({$0.drank == self.drank && $0.orderedFor == self.user}).count
        title = drank.naam
        naamCell.detailTextLabel!.text = drank.naam
        alcoholCell.detailTextLabel!.text = drank.alcoholisch ? "Ja" : "Nee"
        prijsCell.detailTextLabel!.text = "€ \(drank.prijs.description)"
        aantalCell.detailTextLabel!.text = aantalGedronken.description
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !splitViewController!.isCollapsed {
            navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
        }
    }
}
