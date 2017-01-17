import ReachabilitySwift
import RealmSwift
class UpdateService {

   private  let reachability = Reachability()!

    
    
    func testReachability() {
        reachability.whenReachable = { reachability in
            
            if reachability.isReachable {
             //push orders and remove them
                APIService.pushOrders()
            }
            
            DispatchQueue.main.async {
                
                if reachability.isReachable {
                    
                    
                }
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
