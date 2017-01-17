import RealmSwift
//Gebruikt om orders naar de backend te pushen
class AddOrderModel : Object {
    dynamic var orderModelId = UUID().uuidString
    dynamic var orderedById = ""
    dynamic var timestamp = NSTimeIntervalSince1970
    let orderlines = LinkingObjects(fromType: OrderlineModel.self, property: "order")
    
    override static func primaryKey() -> String? {
        return "orderModelId"
    }
}
