import RealmSwift

class ApplicationUser : Object {
    dynamic var userId = ""
    dynamic var totem = ""
    dynamic var email = ""
    
    //Gaat "automatisch" alle objecten van het gekozen type waarin het orderobject voorkomt gaan toevoegen aan deze lijst
    //Zie Realm documentatie voor meer info
    let orders = LinkingObjects(fromType: Order.self, property: "orderedBy")
    let consumpties = LinkingObjects(fromType: Orderline.self, property: "orderedFor")
    
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
