import RealmSwift

class RealmService {
    //Aanpassen bij indienen!
    let  realm: Realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
    
    func addOrUpdate(object : Object) {
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    func findUser(userId : String) -> ApplicationUser
    {
            let user = realm.objects(ApplicationUser.self).filter{$0.userId == userId}.first!
            return user
    }
    
    func findUser(totem: String) -> ApplicationUser {
        //let user = realm.objects(ApplicationUser.self).filter({$0.totem == totem}).first
        guard   let user = realm.objects(ApplicationUser.self).first(where: {$0.totem.lowercased() == totem}) else {
            
            return ApplicationUser()
        }
      
            return user
       
        
    }
    
    
    
    func findDrank(drankId: Int) -> Drank {
        let drank = realm.objects(Drank.self).filter{$0.drankId == drankId}.first!
        return drank
    }
    
    func findOrder(orderId: Int) -> Order {
        let order = realm.objects(Order.self).filter{$0.orderId == orderId}.first!
        return order
    }
    
    func addOutgoingOrder(order: AddOrderModel, lines : [OrderlineModel]) {
        try! realm.write {
            realm.add(lines)
            realm.add(order)
        }
        
        
    }
    
}
