//
//  ViewController.swift
//  DropdownExpandableTBCell
//
//  Created by Max Nelson on 5/28/19.
//  Copyright © 2019 Maxcodes. All rights reserved.
//

import SwiftyJSON
import UIKit
import Alamofire

struct WelcomeElement: Decodable {
    let id: Int
    let name: String
    let published: Int
}

class ModuleController: UIViewController {
    var Strlogin: String = ""
    
    func loging()  {
        AF.request("https://auth.etna-alternance.net/identity").validate().responseJSON { response in
            switch response.result {
            case .success:
                
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let Login = data["login"]
                        //print("utilisateur: \(Login)")
                        self.Strlogin = data["login"].string!
                        let defaults = UserDefaults.standard
                        defaults.setValue(data["login"].string!, forKey: "Strlogin")
                        
                        //self.test()
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
        getData()
    }
    
    fileprivate func getData() {
        let defaults = UserDefaults.standard
        let my_login = defaults.string(forKey: "Strlogin")
        
        let url = URL(string: "https://modules-api.etna-alternance.net/students/\(my_login!)/search")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                
                let users = try JSONDecoder().decode([WelcomeElement].self, from: data!)
                for user in users
                {
                    //print("ID:\(user.id), Name: \(user.name)")
                }
            }
            catch {
                print("error")
            }
        }.resume()
    }
}


