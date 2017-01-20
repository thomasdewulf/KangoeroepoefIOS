import RealmSwift
import Realm
import EVReflection
import Foundation
//Gebruikt om orders naar de backend te pushen. Soort van outbox klasse.
class AddOrderModel : Object {
    
    //UUID source: http://stackoverflow.com/questions/26252432/how-do-i-set-a-auto-increment-key-in-realm
    dynamic var orderModelId = UUID().uuidString
    dynamic var orderedById = ""
    dynamic var timestamp = Date().timeIntervalSince1970
    let orderlines = LinkingObjects(fromType: OrderlineModel.self, property: "order")
    var orderlinesArray : [OrderlineModel] = []

    override static func primaryKey() -> String? {
        return "orderModelId"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["orderlinesArray"]
    }
    
   
}

//Eventueel weghalen als EVReflect niet meer gebruikt wordt.
extension AddOrderModel: EVReflectable {
    func skipPropertyValue(_ value: Any, key: String) -> Bool {
        if key == "orderlines" {
            return true
        }
        return false
    }
}


