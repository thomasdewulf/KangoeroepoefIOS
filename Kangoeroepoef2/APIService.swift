//TODO: - data ophalen van server
//      - data van outbox naar server pushen
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
}
