//
//  PlanningController.swift
//  App-Intra
//
//  Created by Jacques Liao on 15/04/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class PlanningController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var Strlogin: String = ""
    
    var info_start = [String]()
    var info_end = [String]()
    var info_name = [String]()
    var info_uv_name = [String]()
    var info_activity_name = [String]()
    var info_location = [String]()
    
    @IBOutlet weak var table_Data: UITableView!
 
    func getInfos () {
        let defaults = UserDefaults.standard
        let my_login = defaults.string(forKey: "Strlogin")
        
        AF.request("https://intra-api.etna-alternance.net/students/\(my_login!)/events?end=2021-04-19+00:00:00&start=2021-04-12+00:00:00", encoding: URLEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.info_start.removeAll()
                self.info_end.removeAll()
                self.info_name.removeAll()
                self.info_uv_name.removeAll()
                self.info_activity_name.removeAll()
                self.info_location.removeAll()
                
                for infos in json.array!{
                    
                    let ins = infos["start"].stringValue
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "MMM d, h:mm a"
                    
                    if let date = dateFormatterGet.date(from: ins) {
                        self.info_start.append(dateFormatterPrint.string(from: date))
                    }
                    
                    
                    let fin = infos["end"].stringValue
                    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let datePrint = DateFormatter()
                    datePrint.dateFormat = "MMM d, h:mm a"
                    
                    if let date = dateFormatterGet.date(from: fin) {
                        self.info_end.append(dateFormatterPrint.string(from: date))
                    }
                    
                    let name = infos["name"].stringValue
                    self.info_name.append(name)
                    
                    let uv_name = infos["uv_name"].stringValue
                    self.info_uv_name.append(uv_name)
                   
                    
                    let activity_name = infos["activity_name"].stringValue
                    
                    self.info_activity_name.append(activity_name)
                    
                    let location = infos["location"].stringValue
                    self.info_location.append(location)
                    
                }
                self .table_Data.reloadData()
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info_uv_name.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PlanningTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PlanningTableViewCell
        cell.start.text = info_start[indexPath.row]
        cell.end.text = info_end[indexPath.row]
        cell.name.text = info_name[indexPath.row]
        cell.uv_name.text = info_uv_name[indexPath.row]
        cell.activity_name.text = info_activity_name[indexPath.row]
        cell.location.text = info_location[indexPath.row]

        return cell
    }
    
    func loging()  {
        AF.request("https://auth.etna-alternance.net/identity").validate().responseJSON { response in
            switch response.result {
            case .success:
                
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        
                        self.Strlogin = data["login"].string!
                        let defaults = UserDefaults.standard
                        defaults.setValue(data["login"].string!, forKey: "Strlogin")
                        // On appelle la fonction permettant de récupérer données des informations
                        self.getInfos ()
                    }
                    catch{
                        print("JSON Error")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loging()
    }
    

}
