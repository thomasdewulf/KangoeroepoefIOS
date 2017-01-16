import UIKit

class DrankOverviewController : UITableViewController {
  var user : ApplicationUser!
    var indexForPushedAccesory: Int!
  private let dranken = RealmService.realm.objects(Drank.self)
    override func viewDidLoad() {
        splitViewController!.delegate = self
    }
    
    @IBAction func cancelAddOrder(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func saveOrder(segue: UIStoryboardSegue) {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let navController = segue.destination as! UINavigationController
            let detailController = navController.topViewController as! DrankDetailController
           
            detailController.drank = dranken[indexForPushedAccesory!]
        } else if segue.identifier == "addOrder" {
            let navController = segue.destination as! UINavigationController
            let orderController = navController.topViewController as! AddOrderController
            let index = tableView.indexPathForSelectedRow!.row
            orderController.drank = dranken[index]
            orderController.user = user
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //detailscherm tonen van drank
        indexForPushedAccesory = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
        print("kleine knop")
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //naar overzicht gaan voor dranken kiezen
        performSegue(withIdentifier: "addOrder", sender: self)
        print("cel zelf")
    }
}

//overgenomen uit oplossing "splitview"
extension DrankOverviewController: UISplitViewControllerDelegate{
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
