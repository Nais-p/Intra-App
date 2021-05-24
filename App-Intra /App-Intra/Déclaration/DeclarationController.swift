//
//  DeclarationController.swift
//  App-Intra
//
//  Created by Anaïs Puig on 15/04/2021.
//

import SwiftyJSON
import UIKit
import Alamofire
import Foundation

class DeclarationController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    // Déclaration des variables "globales"
    var Strlogin: String = ""
    var Strpromo = ""
    
    let viewImageSegueIdentifier = "viewImageSegueIdentifier"
    var id_module = ""
    
    // Variable permettant l'affichage des modules dans collection view
    var dc_date = [String]()
    var dc_mod = [String]()
    var dc_act = [String]()
    var dc_obj = [String]()
    var dc_hfin = [String]()
    var dc_fin = [String]()
    var dc_hdeb = [String]()
    var dc_deb = [String]()
   

    //Fonction permettant de récupérer les informations concernant les modules.
    func Module() {
        let defaults = UserDefaults.standard
        let my_login = defaults.string(forKey: "Strlogin")
        print("https://gsa-api.etna-alternance.net/students/\(my_login!)/declarations")
        AF.request("https://gsa-api.etna-alternance.net/students/\(my_login!)/declarations", encoding: URLEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print(json)
                self.dc_date.removeAll()
                self.dc_mod.removeAll()
                self.dc_act.removeAll()
                self.dc_obj.removeAll()
                self.dc_hfin.removeAll()
                self.dc_fin.removeAll()
                self.dc_hdeb.removeAll()
                self.dc_deb.removeAll()
//                print("=======================================")
//                print(json)
//                print("=======================================")
                print(json["total"])

                for infos in json["hits"] {
                    
                    print(infos.1["uv_name"])
                    let date = infos.1["start"].stringValue
                    self.dc_date.append(date)
                    
                    let module = infos.1["uv_name"].stringValue
                    self.dc_mod.append(module)
                    
                   let objec = infos.1["metas"]["description"].stringValue
                    self.dc_obj.append(objec)
                    
                    let deb = infos.1["start"].stringValue
                     self.dc_hdeb.append(deb)
                    
                    let fin = infos.1["end"].stringValue
                     self.dc_hfin.append(fin)
                    
                   
                     self.dc_act.append("Les objectifs de votre séance de travail \nLes actions réalisées \nLes résultats obtenus et problèmes rencontrés")
                    self.dc_fin.append("Fin")
                    self.dc_deb.append("Début")
                    
                    print(infos.1["metas"]["description"])
                                      

                    //                    self.dc_date.append(date)
                    //print(infos["total"].stringValue)
//                    let date = infos["total"].stringValue
//                    self.dc_date.append(date)

                    //print(self.dc_date)
//                    let name = item["uv"]["name"].stringValue
//                    self.dc_date.append(name)

//                    let id = item["id"].stringValue
//                    self.uv_id.append(id)

                }
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
                self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
                break
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    // Fonction permettant de récupérer le login de la personne connectée (essentielles aux autres requêtes) ainsi que l'email de l'utilisateur
    func loging()  {
        AF.request("https://auth.etna-alternance.net/identity").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        
                        // On enregistre le login de l'utilisateur dans Strlogin et on le save dans defaults pour l'appeller dans les autres fonctions
                        self.Strlogin = data["login"].string!
                        let defaults = UserDefaults.standard
                        defaults.setValue(data["login"].string!, forKey: "Strlogin")
                        
                        // Appel de toutes les fonctions qui récupère le login
                        self.Module()
                        
                       
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
        self.automaticallyAdjustsScrollViewInsets = false

    }
    
    var Item: String = ""
    
    
   
    
}


// Extension afin de gérer les collectionView permettant d'afficher les informations
extension DeclarationController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dc_date.count
    }
    
    //Fonction permettant de gérer l'affichage des modules depuis le fichier "displaymoduleCell"
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "De_clarationsCollectionViewCell", for: indexPath) as! De_clarationsCollectionViewCell
        cell.date.text = self.dc_date[indexPath.row]
        cell.module.text = self.dc_mod[indexPath.row]
        cell.actions.text = self.dc_act[indexPath.row]
        cell.objectifs.text = self.dc_obj[indexPath.row]
        cell.fin.text = self.dc_fin[indexPath.row]
        cell.debut.text = self.dc_deb[indexPath.row]
        cell.hfin.text = self.dc_hfin[indexPath.row]
        cell.hdebut.text = self.dc_hdeb[indexPath.row]

        
       
        return cell
    }
}

//Fonction qui définit la taille de la collectionView.
extension DeclarationController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let numberOfItemsPerRow: CGFloat = 1
        let width = (collectionView.frame.width-numberOfItemsPerRow)
        return CGSize(width: width, height: 383)
    }

    func roundCorner() {
        self.collectionView.layer.cornerRadius = 12.0
        self.collectionView.layer.masksToBounds = true
        self.collectionView.layer.borderWidth = 1.0
        self.collectionView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top, left, bottom, right
        return UIEdgeInsets(top: 20, left: 0, bottom: 150, right: 0)
    }
}


