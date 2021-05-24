//
//  NoteViewController.swift
//  App-Intra
//
//  Created by Jacques Liao on 13/04/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var Strlogin: String = ""
    
    var info_uv_name = [String]()
    var info_uv_long_name = [String]()
    var info_activity_name = [String]()
    var info_my_note = [Double]()
    var info_moy_promo = [Double]()
    var info_min_note = [String]()
    var info_max_note = [String]()
    
    @IBOutlet weak var table_Data: UITableView!
 
    func getInfos () {
        let defaults = UserDefaults.standard
        let my_login = defaults.string(forKey: "Strlogin")
        
        AF.request("https://intra-api.etna-alternance.net/terms/629/students/\(my_login!)/marks", encoding: URLEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.info_uv_name.removeAll()
                self.info_uv_long_name.removeAll()
                self.info_activity_name.removeAll()
                self.info_my_note.removeAll()
                self.info_moy_promo.removeAll()
                self.info_min_note.removeAll()
                self.info_max_note.removeAll()
                
                for infos in json.array!{
                    let uv_name = infos["uv_name"].stringValue
                    self.info_uv_name.append(uv_name)
                    
                    let uv_long_name = infos["uv_long_name"].stringValue
                    self.info_uv_long_name.append(uv_long_name)
                    
                    let activity_name = infos["activity_name"].stringValue
                    self.info_activity_name.append(activity_name)
                    
                    let student_mark = infos["student_mark"].doubleValue
                    self.info_my_note.append(student_mark)
                   
                    
                    let average = infos["average"].doubleValue
                    
                    let x = average
                    let y = Double(round(x*1000)/1000)
                    self.info_moy_promo.append(y)
                    
                    let minimal = infos["minimal"].stringValue
                    self.info_min_note.append(minimal)
                    
                    let maximal = infos["maximal"].stringValue
                    self.info_max_note.append(maximal)
                }
                self .table_Data.reloadData()
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info_max_note.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NoteTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NoteTableViewCell
        cell.uv_name.text = info_uv_name[indexPath.row]
        cell.uv_long_name.text = info_uv_long_name[indexPath.row]
        cell.activity_name.text = info_activity_name[indexPath.row]
        let my_note_display = info_my_note[indexPath.row]
        cell.my_note.text = String(my_note_display)
//        let myString1 = info_moy_promo[indexPath.row]
//        let myInt1 = Double(myString1)
//        let roundedValue1 = (myInt1! * 1000).rounded() / 1000
//        print(roundedValue1)
        cell.moy_promo.text = String(info_moy_promo[indexPath.row])
        cell.min_note.text = info_min_note[indexPath.row]
        cell.max_note.text = info_max_note[indexPath.row]

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
