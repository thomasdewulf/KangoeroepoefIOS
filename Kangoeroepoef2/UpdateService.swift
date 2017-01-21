import ReachabilitySwift
import RealmSwift
class UpdateService {

   private  let reachability = Reachability()!
   
    
    
    func startReachabilityNotifier() {
        reachability.whenReachable = { reachability in
            
            if reachability.isReachable {
             //push orders and remove them
                print("reachable")
                let api = APIService()
                //self.api.realm.realm =  try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
               api.pushOrders()
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
