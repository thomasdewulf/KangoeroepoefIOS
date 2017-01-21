//TODO:
//      - parse methodes proberen herwerken naar 1 methode -> EVReflect?
import Alamofire
import SwiftyJSON
import EVReflection
import RealmSwift
class APIService {
    
    //realm
     let realm = RealmService()
    
     let links : NSDictionary
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    init() {
        let path = Bundle.main.path(forResource: "APILinks", ofType: "plist")!
        links = NSDictionary(contentsOfFile: path)!
      
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

    }
    
    func getUserData() {
        activityIndicator.startAnimating()
        let link = links["users"] as! String
        
        Alamofire.request(link).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseUserJSON(json: json)
            case .failure(let error) :
                print(error.localizedDescription)
                
            }
            self.activityIndicator.stopAnimating()
        }
    }
    func getDrankData() {
        let link = links["dranken"] as! String
        
        Alamofire.request(link).responseJSON {
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
    
     func getOrderData() {
        let realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
        let orderlines = realm.objects(Order.self)
        var maxId = orderlines.max(ofProperty: "orderId") as Int?
        if maxId == nil {
            maxId = 0
        }
        var link = links["orders"] as! String
        link.append(maxId!.description)
        
       
        
        Alamofire.request(link).responseJSON {
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
  
    
    
     func pushOrders()
    {
        let realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
        let orderModels = realm.objects(AddOrderModel.self)

        let linkMultiple = links["create"] as! String
      
        var parameters = [[String: Any]]()
  
            for order in orderModels {
                 order.orderlinesArray = Array(order.orderlines)
                parameters.append(parseOrderModel(model: order))
           
          
        }
        
        print(parameters)
        
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
                    
                   let realm =  try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
                    try! realm.write {
                      
                        realm.delete(realm.objects(OrderlineModel.self))
                        realm.delete(realm.objects(AddOrderModel.self))
                    }
                    
                case 500?:
                    print("Server error. Status 500")
                default:
                    print("Iets anders ging fout. Statuscode: \(response.response?.statusCode)")
                }
                
                
            }
        }
        
        print("Geen orders in outbox.")
    
     
    }
   
    private  func parseOrderModel(model : AddOrderModel) -> [String: Any] {
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
    
     //Deze functies herwerken!!
    //Parse the JSON and update the local db
private    func parseUserJSON(json : JSON) {
   //  let realm = try! Realm(fileURL: URL(fileURLWithPath: "Users/thomasdewulf/Desktop/testRealm.realm"))
   
        for (_,subJson):(String, JSON) in json {
        let user = ApplicationUser()
            user.email = subJson["email"].stringValue
            user.userId = subJson["userId"].stringValue
            user.totem = subJson["totem"].stringValue
            self.realm.addOrUpdate(object: user)
        }
    }
    
    
    private    func parseDrankJSON(json : JSON) {
        for (_,subJson):(String, JSON) in json {
            let drank = Drank()
            drank.naam = subJson["naam"].stringValue
            drank.alcoholisch = subJson["alcoholisch"].boolValue
            drank.drankId  = subJson["drankId"].intValue
            drank.prijs = subJson["prijs"].doubleValue
            realm.addOrUpdate(object: drank)
        }
    }
    
    
    private    func parseOrderJSON(json : JSON) {
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
    
    private func parseOrderlineJSON(json : JSON, order: Order) {
        for (_,subJson):(String, JSON) in json {
            let orderline = Orderline()
            orderline.orderlineId = subJson["orderLineId"].intValue
            let drankId = subJson["drank"]["drankId"].intValue
            let drank = realm.findDrank(drankId: drankId)
            orderline.drank = drank
           
            
            orderline.order = order
            var user : ApplicationUser?
            if subJson["orderedForId"].stringValue != "" {
                let userId = subJson["orderedForId"].stringValue
                user = self.realm.findUser(userId: userId)
                orderline.orderedFor = user
                realm.addOrUpdate(object: orderline)
            }
            
        
        }
    }
}


