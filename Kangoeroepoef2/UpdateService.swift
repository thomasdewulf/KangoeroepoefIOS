import ReachabilitySwift
import RealmSwift
class UpdateService {

   private  let reachability = Reachability()!
    private let api = APIService()
    
    
    func startReachabilityNotifier() {
        reachability.whenReachable = { reachability in
            
            if reachability.isReachable {
             //push orders and remove them
                print("reachable")
                self.api.pushOrders()
            }
            
         
        }
        reachability.whenUnreachable = { reachability in
       
            DispatchQueue.main.async {
                print("Not reachable")
                //Balk onderaan weergeven?
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    
    
 
}
