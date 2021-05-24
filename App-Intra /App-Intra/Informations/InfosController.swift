//
//  test2.swift
//  App-Intra
//
//  Created by Anaïs Puig on 12/04/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class InfosController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var Strlogin: String = ""
    
    var info_mess = [String]()
    var info_date = [String]()
    
    @IBOutlet weak var table_Data: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info_mess.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:InfosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! InfosTableViewCell
        cell.mess.text = info_mess[indexPath.row]
        cell.date.text = info_date[indexPath.row]
        return cell
    }
    
    // Fonction permettant de récupérer les dates et messages des informations
    func getInfos () {
        let defaults = UserDefaults.standard
        let my_login = defaults.string(forKey: "Strlogin")
        
        AF.request("https://intra-api.etna-alternance.net/students/\(my_login!)/informations/archived", encoding: URLEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.info_mess.removeAll()
                self.info_date.removeAll()
                
                for infos in json.array!{
                    let date = infos["start"].stringValue
                    self.info_date.append(date)
                    
                    let message = infos["message"].stringValue
                    self.info_mess.append(message)
                }
                // On recharge la table view pour afficher les données
                self .table_Data.reloadData()
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // On refait la fonction pour récupérer le login du user dans ce controller également.
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
