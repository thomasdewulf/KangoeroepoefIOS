//check for empty textfield: http://stackoverflow.com/questions/24102641/how-to-check-if-a-text-field-is-empty-or-not-in-swift

import UIKit

class LoginViewController : UIViewController {
    //Outlets
    @IBOutlet weak var totemTextField : UITextField!
    @IBOutlet weak var errorLabel : UILabel!
    
    //realm
    let realm = RealmService()
    //vars
    private var loggedinUser: ApplicationUser!
    
    let api = APIService()
    
    override func viewDidLoad() {
      
        errorLabel.text = ""
        api.getUserData()
        api.getDrankData()
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loader.translatesAutoresizingMaskIntoConstraints = false
           self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.view.addConstraints(
        [
            loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loader.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            loader.heightAnchor.constraint(equalTo: self.view.heightAnchor)
            ])
     
        loader.startAnimating()
       
        DispatchQueue.global(qos: .background).async {
            self.api.getOrderData(loader: loader)
            
           
            
            
        }
       
     
        }
    
    @IBAction func login() {
        
        guard let totem = totemTextField.text, !totem.isEmpty else {
            
            errorLabel.text = "Gelieve totemnaam in te vullen."
            return
        }
        //Andere manier zoeken.
        guard let user : ApplicationUser = realm.findUser(totem: totem), !user.userId.isEmpty else{
              errorLabel.text = "Gebruiker niet gevonden. Probeer opnieuw"
            return
        }
        
        errorLabel.text = ""
        loggedinUser = user
        
        performSegue(withIdentifier: "loggedIn", sender: self)
    }
    
    @IBAction func logout(segue: UIStoryboardSegue) {
    loggedinUser = nil
        totemTextField.text = ""
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let drankenController = segue.destination as! UISplitViewController
        let navController = drankenController.viewControllers[0] as! UINavigationController
        let overview = navController.topViewController as! DrankOverviewController
        overview.user = loggedinUser
    }
}
