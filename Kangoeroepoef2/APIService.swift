//TODO: 
//
//      - Links opslaan in properties file
//      - parse methodes proberen herwerken naar 1 methode -> EVReflect?
import Alamofire
import SwiftyJSON
import EVReflection
import RealmSwift
class APIService {
    
    //realm
    static let realm = RealmService()

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
        let orderlines = realm.realm.objects(Order.self)
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
  
    
    
    static func pushOrders()
    {
       
        let orderModels = realm.realm.objects(AddOrderModel.self)
       // let linkSingle = "http://localhost:5000/api/order"
        let linkMultiple = "http://localhost:5000/api/order/createMultiple"
       // var link = ""
        var parameters = [[String: Any]]()
       /* if orderModels.count == 1 {
            let order = orderModels.first!
            order.orderlinesArray = Array(order.orderlines)
            link = linkSingle
            parameters.append( parseOrderModel(model: order))
            print(parameters)
        }
        else {*/
          //  link = linkMultiple
            for order in orderModels {
                 order.orderlinesArray = Array(order.orderlines)
                parameters.append(parseOrderModel(model: order))
                
           // }
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
                    
                   
                    try! realm.realm.write {
                        //realm.delete(realm.objects(AddOrderModel.self))
                        realm.realm.delete(realm.realm.objects(OrderlineModel.self))
                        realm.realm.delete(realm.realm.objects(AddOrderModel.self))
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
            realm.addOrUpdate(object: user)
        }
    }
    
    
    private   static func parseDrankJSON(json : JSON) {
        for (_,subJson):(String, JSON) in json {
            let drank = Drank()
            drank.naam = subJson["naam"].stringValue
            drank.alcoholisch = subJson["alcoholisch"].boolValue
            drank.drankId  = subJson["drankId"].intValue
            drank.prijs = subJson["prijs"].doubleValue
            realm.addOrUpdate(object: drank)
        }
    }
    
    
    private   static func parseOrderJSON(json : JSON) {
        for (_,subJson):(String, JSON) in json {
          let order = Order()
           order.orderId = subJson["orderId"].intValue
            order.timestamp = subJson["timestamp"].doubleValue
            let userId = subJson["orderedBy"]["id"].stringValue
            
            let orderedBy = realm.findUser(userId: userId)
            order.orderedBy = orderedBy
            let orderlines = subJson["orderlines"]
            
            realm.addOrUpdate(object: order)
            
            parseOrderlineJSON(json: orderlines, order: order)
        }
    }
    
    private   static func parseOrderlineJSON(json : JSON, order: Order) {
        for (_,subJson):(String, JSON) in json {
            let orderline = Orderline()
            orderline.orderlineId = subJson["orderLineId"].intValue
            let drankId = subJson["drank"]["drankId"].intValue
            let drank = realm.findDrank(drankId: drankId)
            orderline.drank = drank
           
            
            orderline.order = order
            let userId = subJson["orderedForId"].stringValue
            let user = realm.findUser(userId: userId)
            orderline.orderedFor = user
                       realm.addOrUpdate(object: orderline)
        }
    }
}


