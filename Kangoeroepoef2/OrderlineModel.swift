import RealmSwift
import EVReflection

class OrderlineModel : Object {
    
    dynamic var orderlineModelId = UUID().uuidString
    dynamic var drankId = 0
    dynamic var orderedForId = ""
    dynamic var order : AddOrderModel?
    
    
    override static func primaryKey() -> String? {
        return "orderlineModelId"
    }
}
extension OrderlineModel: EVReflectable {
    
}
