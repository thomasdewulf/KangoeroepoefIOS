import RealmSwift

class Drank : Object {
    dynamic var naam = ""
    dynamic var drankId = 0
    dynamic var prijs : Double = 0.0
    dynamic var alcoholisch  = false
    
    override static func primaryKey() -> String? {
        return "drankId"
    }
}
