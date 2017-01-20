import UIKit
import RealmSwift
class AddOrderController : UITableViewController {
    //vars
    var drank : Drank!
    var user: ApplicationUser!
    var users : Results<ApplicationUser>!
    var aantallen = [ApplicationUser : Int]()
    //Realm
    let realm = RealmService()
    
    //Outlets
    @IBOutlet weak var doneButton : UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
   
    
    override func viewDidLoad() {
        title = drank.naam
        doneButton.isEnabled =  disableButtons()
        
        users = realm.realm.objects(ApplicationUser.self)
        
        for user in users {
            aantallen[user] = 0
        }
        
    }
    
    //source: http://stackoverflow.com/questions/28548939/swift-tableview-of-steppers-click-one-stepper-in-a-cell-and-other-steppers-ge
    @IBAction func stepperChanged(sender: UIStepper) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = self.tableView.indexPathForRow(at: point)!
        
        aantallen[users[indexPath.row]] = Int(sender.value)
        
        //Cell van stepper ophalen
        let cell = tableView.cellForRow(at: indexPath) as! OrderCell
        //aangeduide user zoeken
        let user = users[indexPath.row]
        
        //Label wijzigen om waarde van de stepper te reflecteren
        cell.userLabel?.text = "\(user.totem) (\(Int(sender.value).description))"
        
        doneButton.isEnabled =  disableButtons()
        
    }
    
    func disableButtons() -> Bool {
        
        var sum = 0
        for aantal in aantallen.values {
            sum = sum + aantal
        }
        
        if sum == 0 {
            return false
        }
        
        return true
    }
    
        //Vooral nodig wanneer app op Ipad wordt gedraaid. Scherm verandert niet wanneer een bestelling wordt geplaatst. Waarden worden ook niet gereset dus.
    func resetTable() {
    
        tableView.reloadData()//reload the correct names
        users = realm.realm.objects(ApplicationUser.self)
        for user in users {
            aantallen[user] = 0
        }
        doneButton.isEnabled = disableButtons()
       for cell in tableView.visibleCells
       {
        let orderCell = cell as! OrderCell
       
        orderCell.stepper.value = 0
        }
    }
    
    //Tableview opzetten
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return users.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell",for: indexPath) as! OrderCell
     
  
            let user = users[indexPath.row]
            cell.userLabel?.text = user.totem
        
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

//custom cell source: https://www.ralfebert.de/tutorials/ios-swift-uitableviewcontroller/custom-cells/
//Custom cell om zo de UIStepper te kunnen manipuleren in code
class OrderCell: UITableViewCell {
 
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    
}
