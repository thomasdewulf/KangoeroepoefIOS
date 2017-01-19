import UIKit
import RealmSwift
class AddOrderController : UITableViewController {
    var drank : Drank!
    var user: ApplicationUser!
    var users : Results<ApplicationUser>!
    var aantallen = [ApplicationUser : Int]()
    
    @IBOutlet weak var doneButton : UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
   
    
    override func viewDidLoad() {
       disableButtons()
        users = RealmService.realm.objects(ApplicationUser.self)
        for user in users {
            aantallen[user] = 0
        }
        title = drank.naam
    }
    //source: http://stackoverflow.com/questions/28548939/swift-tableview-of-steppers-click-one-stepper-in-a-cell-and-other-steppers-ge
    @IBAction func stepperChanged(sender: UIStepper) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = self.tableView.indexPathForRow(at: point)!
        
        aantallen[users[indexPath.row]] = Int(sender.value)
       let cell = tableView.cellForRow(at: indexPath) as! OrderCell
        let user = users[indexPath.row]
        cell.userLabel?.text = "\(user.totem) (\(Int(sender.value).description))"
    disableButtons()
        
    }
    
    func disableButtons() {
       // http://stackoverflow.com/questions/39553054/sum-of-values-in-a-dictionary-swift
        var sum = 0
        for aantal in aantallen.values {
            sum = sum + aantal
        }
        if sum == 0 {
            doneButton.isEnabled = false
            cancelButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
            cancelButton.isEnabled = true
        }
    }
    
    func resetTable() {
        tableView.reloadData()//reload the correct names
        users = RealmService.realm.objects(ApplicationUser.self)
        for user in users {
            aantallen[user] = 0
        }
        disableButtons()
       for cell in tableView.visibleCells
       {
        let orderCell = cell as! OrderCell
       
        orderCell.stepper.value = 0
        }
    }
    
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

class OrderCell: UITableViewCell {
 
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    
}
