//TODO: - data ophalen van server
//      - data van outbox naar server pushen
//      - Links opslaan in properties file
import Alamofire
import SwiftyJSON
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
}
