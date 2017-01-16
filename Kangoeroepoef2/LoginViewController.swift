//check for empty textfield: http://stackoverflow.com/questions/24102641/how-to-check-if-a-text-field-is-empty-or-not-in-swift

import UIKit

class LoginViewController : UIViewController {
    @IBOutlet weak var totemTextField : UITextField!
    @IBOutlet weak var errorLabel : UILabel!
    private var loggedinUser: ApplicationUser!
    override func viewDidLoad() {
    errorLabel.text = ""
    }
    @IBAction func login() {
        guard let totem = totemTextField.text, !totem.isEmpty else {
            errorLabel.text = "Gelieve totemnaam in te vullen."
            return
        }
       // let totem = totemTextField.text
      //  let user = RealmService.findUser(totem: totem)
       
        guard let user : ApplicationUser = RealmService.findUser(totem: totem), !user.userId.isEmpty else{
              errorLabel.text = "Gebruiker niet gevonden. Probeer opnieuw"
            return
        }
        
        errorLabel.text = ""
        loggedinUser = user
        performSegue(withIdentifier: "loggedIn", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let drankenController = segue.destination as! UISplitViewController
        let navController = drankenController.viewControllers[0] as! UINavigationController
        let overview = navController.topViewController as! DrankOverviewController
        overview.user = loggedinUser
    }
}
