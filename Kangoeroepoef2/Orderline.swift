import RealmSwift

class Orderline : Object {
    
    dynamic var orderlineId = 0
    dynamic var drank : Drank?
    dynamic var orderedFor: ApplicationUser?
    dynamic var order: Order?
    
    
    override static func primaryKey() -> String? {
        return "orderlineId"
    }
}
