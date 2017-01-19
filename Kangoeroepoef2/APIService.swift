//TODO: 
//
//      - Links opslaan in properties file
//      - parse methodes proberen herwerken naar 1 methode -> EVReflect?
import Alamofire
import SwiftyJSON
import EVReflection
import RealmSwift
class APIService {

    static func getUserData() {
        let ApplicationUserlink = "http://localhost:5000/api/ApplicationUser"
        
        Alamofire.request(ApplicationUserlink).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseUserJSON(json: json)
            case .failure(let error) :
                print(error.localizedDescription)
                
            }
        }
    }
    static func getDrankData() {
        let ApplicationUserlink = "http://localhost:5000/api/Dranken"
        
        Alamofire.request(ApplicationUserlink).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseDrankJSON(json: json)
            case .failure(let error) :
                print(error.localizedDescription)
                
            }
        }
    }
    
    static func getOrderData() {
        let orderlines = RealmService.realm.objects(Order.self)
        var maxId = orderlines.max(ofProperty: "orderId") as Int?
        if maxId == nil {
            maxId = 0
        }
        let ApplicationUserlink = "http://localhost:5000/api/Order/NewOrders?id=\(maxId!.description)"
        
        Alamofire.request(ApplicationUserlink).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseOrderJSON(json: json)
            case .failure(let error) :
                print(error.localizedDescription)
                
            }
        }
    }
    static func getOrderlineData() {
       
        let orderlines = RealmService.realm.objects(Orderline.self)
        var maxId = orderlines.max(ofProperty: "orderlineId") as Int?
        if maxId == nil {
           maxId = 0
        }
        let applicationUserlink = "http://localhost:5000/api/Order/NewLines?id=\(maxId!.description)"
        
        Alamofire.request(applicationUserlink).responseJSON {
            
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseOrderlineJSON(json: json)
            case .failure(let error) :
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    static func pushOrders()
    {
        let realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
        let orderModels = realm.objects(AddOrderModel.self)
        let linkSingle = "http://localhost:5000/api/order"
        let linkMultiple = "http://localhost:5000/api/order/createMultiple"
        var link = ""
        var parameters = [[String: Any]]()
        if orderModels.count == 1 {
            let order = orderModels.first!
            order.orderlinesArray = Array(order.orderlines)
            link = linkSingle
            parameters.append( parseOrderModel(model: order))
            print(parameters)
        }
        else {
            link = linkMultiple
            for order in orderModels {
                 order.orderlinesArray = Array(order.orderlines)
                parameters.append(parseOrderModel(model: order))
                
            }
        }
        
        if orderModels.count >= 1 {
            var test = URLRequest(url: URL(string: linkMultiple)!)
            test.httpMethod = "POST"
            
            let data = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            test.setValue("application/json", forHTTPHeaderField: "Content-Type")
            test.httpBody = data
            
            
            
            Alamofire.request(test).response {
                response in
                switch response.response?.statusCode {
                case 200? :
                    print("hoera!")
                    
                    let realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
                    try! realm.write {
                        //realm.delete(realm.objects(AddOrderModel.self))
                        realm.delete(realm.objects(OrderlineModel.self))
                        realm.delete(realm.objects(AddOrderModel.self))
                    }
                    
                case 500?:
                    print("spijtig")
                default:
                    print("nog meer spijt")
                }
                
                
            }
        }
        
        print("no orders to post")
    
     
    }
    
    private static func parseOrderModel(model : AddOrderModel) -> [String: Any] {
        var json = [String: Any]()
        json["orderedById"] = model.orderedById
        json["timestamp"] = model.timestamp
        var orderlines = [[String: Any]]()
        for line in model.orderlinesArray {
            var lineJson = [String: Any]()
            lineJson["drankId"] = line.drankId
            lineJson["orderedForId"] = line.orderedForId
            orderlines.append(lineJson)
        }
        json["orderlines"] = orderlines
        
        return json
    }
    //Parse the JSON and update the local db
private   static func parseUserJSON(json : JSON) {
        for (_,subJson):(String, JSON) in json {
        let user = ApplicationUser()
            user.email = subJson["email"].stringValue
            user.userId = subJson["userId"].stringValue
            user.totem = subJson["totem"].stringValue
            RealmService.addOrUpdate(object: user)
        }
    }
    
    
    private   static func parseDrankJSON(json : JSON) {
        for (_,subJson):(String, JSON) in json {
            let drank = Drank()
            drank.naam = subJson["naam"].stringValue
            drank.alcoholisch = subJson["alcoholisch"].boolValue
            drank.drankId  = subJson["drankId"].intValue
            drank.prijs = subJson["prijs"].doubleValue
            RealmService.addOrUpdate(object: drank)
        }
    }
    
    
    private   static func parseOrderJSON(json : JSON) {
        for (_,subJson):(String, JSON) in json {
          let order = Order()
           order.orderId = subJson["orderId"].intValue
            order.timestamp = subJson["timestamp"].doubleValue
            let userId = subJson["orderedBy"]["id"].stringValue
            
            let orderedBy = RealmService.findUser(userId: userId)
            order.orderedBy = orderedBy
            RealmService.addOrUpdate(object: order)
        }
    }
    
    private   static func parseOrderlineJSON(json : JSON) {
        for (_,subJson):(String, JSON) in json {
            let orderline = Orderline()
            orderline.orderlineId = subJson["orderLineId"].intValue
            let drankId = subJson["drank"]["drankId"].intValue
            let drank = RealmService.findDrank(drankId: drankId)
            orderline.drank = drank
            let orderId = subJson["order"]["orderId"].intValue
            let order = RealmService.findOrder(orderId: orderId)
            orderline.order = order
            let userId = subJson["orderedFor"]["id"].stringValue
            let user = RealmService.findUser(userId: userId)
            orderline.orderedFor = user
                       RealmService.addOrUpdate(object: orderline)
        }
    }
}


