import RealmSwift

class ApplicationUser : Object {
    dynamic var userId = ""
    dynamic var totem = ""
    dynamic var email = ""

    //let orders = List<Order>()
    let orders = LinkingObjects(fromType: Order.self, property: "orderedBy")
    let consumpties = LinkingObjects(fromType: Orderline.self, property: "orderedFor")
    
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
