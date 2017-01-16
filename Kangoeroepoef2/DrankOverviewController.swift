import UIKit

class DrankOverviewController : UITableViewController {
  var user : ApplicationUser!
  private let dranken = RealmService.realm.objects(Drank.self)
    override func viewDidLoad() {
        splitViewController!.delegate = self
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dranken.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drankCell",for: indexPath)
        let drank = dranken[indexPath.row]
        cell.textLabel!.text = drank.naam
        cell.detailTextLabel!.text = " € \(drank.prijs.description)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //detailscherm tonen van drank
        print("kleine knop")
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //naar overzicht gaan voor dranken kiezen
        print("cel zelf")
    }
}

//overgenomen uit oplossing "splitview"
extension DrankOverviewController: UISplitViewControllerDelegate{
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
