import RealmSwift

class Order : Object {
    dynamic var orderId = 0
    dynamic var orderedBy: ApplicationUser?
    dynamic var timestamp = NSTimeIntervalSince1970
    let orderlines = List<Orderline>()
}
