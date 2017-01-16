import RealmSwift

class RealmService {
   static  let  realm: Realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
    
   static func addOrUpdate(object : Object) {
        try! realm.write {
            realm.add(object, update: true)
        }
    }
}
