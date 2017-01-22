import RealmSwift

class RealmService {
    //Aanpassen bij indienen!
    var  realm: Realm 
    init() {
         realm = try! Realm()
    }
    
    
    func addOrUpdate(object : Object) {
       //  realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    func findUser(userId : String) -> ApplicationUser
    { //realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
            let user = realm.objects(ApplicationUser.self).filter{$0.userId == userId}.first!
            return user
    }
    
    func findUser(totem: String) -> ApplicationUser {
        // realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
        //let user = realm.objects(ApplicationUser.self).filter({$0.totem == totem}).first
        guard   let user = realm.objects(ApplicationUser.self).first(where: {$0.totem.lowercased() == totem}) else {
            
            return ApplicationUser()
        }
      
            return user
       
        
    }
    
    
    
    func findDrank(drankId: Int) -> Drank {
       //  realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
        let drank = realm.objects(Drank.self).filter{$0.drankId == drankId}.first!
        return drank
    }
    
    func findOrder(orderId: Int) -> Order {
      //   realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
        let order = realm.objects(Order.self).filter{$0.orderId == orderId}.first!
        return order
    }
    
    func addOutgoingOrder(order: AddOrderModel, lines : [OrderlineModel]) {
        // realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
        try! realm.write {
            realm.add(lines)
            realm.add(order)
        }
        
        
    }
    
}
