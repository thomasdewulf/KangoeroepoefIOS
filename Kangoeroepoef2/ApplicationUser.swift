import RealmSwift

class ApplicationUser : Object {
    dynamic var userId = ""
    dynamic var totem = ""
    dynamic var email = ""
    let orders = List<Order>()
    let consumpties = List<Orderline>()
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
