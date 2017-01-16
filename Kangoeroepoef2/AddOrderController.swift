import UIKit
import RealmSwift
class AddOrderController : UITableViewController {
    var drank : Drank!
    var user: ApplicationUser!
    var users : Results<ApplicationUser>!
    override func viewDidLoad() {
       
        users = RealmService.realm.objects(ApplicationUser.self).filter("userId != %@", user.userId)
        title = drank.naam
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
       
        return 1
        }
        else if section == 1 {
       
        return users.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell",for: indexPath) as! OrderCell
        if indexPath.section == 0
        {
         cell.userLabel?.text = user.totem
        }
        else if indexPath.section == 1 {
            let user = users[indexPath.row]
            cell.userLabel?.text = user.totem
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}

//custom cell source: https://www.ralfebert.de/tutorials/ios-swift-uitableviewcontroller/custom-cells/

class OrderCell: UITableViewCell {
 
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
}
