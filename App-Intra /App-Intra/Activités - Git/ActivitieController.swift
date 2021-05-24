//
//  ActivitieController.swift
//  App-Intra
//
//  Created by Jacques Liao on 13/04/2021.
//

import SwiftyJSON
import UIKit
import Alamofire
import Foundation

class ActivitieController: UIViewController {
    @IBOutlet weak var ViewCollection: UICollectionView!
    
    var Mid = ""
    var Strlogin: String = ""
    var Strpromo = ""
    
    let Rendu = "Rendu"
    let Formulaire = "Formulaire"

    
    // Variable permettant l'affichage des modules dans collection view
   
    var act_id = [String]()
    
    var act_nom = [String]()
    var act_insc = [String]()
    var act_inscH = [String]()
    var act_deb = [String]()
    var act_fin = [String]()
    var act_grp = [String]()
    
    
    //Fonction permettant de récupérer les informations concernant les modules.
    func Module() {
        //        let defaults = UserDefaults.standard
        //        let my_login = defaults.string(forKey: "Strlogin")
        
        AF.request("https://modules-api.etna-alternance.net/\(Mid)/activities", encoding: URLEncoding.default).responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print(json)
               
                
                self.act_nom.removeAll()
                self.act_insc.removeAll()
                self.act_inscH.removeAll()
                self.act_deb.removeAll()
                self.act_fin.removeAll()
                self.act_grp.removeAll()
                self.act_id.removeAll()
                
                
                for item in json.array!{
                    let aa = item["type"]
                    if aa == "project" {
                        let id = item["id"].stringValue
                        self.act_id.append(id)
                        
                        let nom = item["name"].stringValue
                        self.act_nom.append(nom)
                        
                        let ins = item["registration_date"].stringValue
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let dateFormatterPrint = DateFormatter()
                        dateFormatterPrint.dateFormat = "MMM d, yyyy"
                        
                        if let date = dateFormatterGet.date(from: ins) {
                            self.act_insc.append("Inscription:  \(dateFormatterPrint.string(from: date)) à")
                        }
                        
                        let dateHFormatterPrint = DateFormatter()
                        dateHFormatterPrint.dateFormat = "HH:mm"
                        
                        let insH = item["registration_date"].stringValue
                        if let Heure = dateFormatterGet.date(from: insH) {
                            self.act_inscH.append((dateHFormatterPrint.string(from: Heure)))
                        }
                        
                        
                        let deb = item["date_start"].stringValue
                        let dateDebGet = DateFormatter()
                        dateDebGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let dateDebPrint = DateFormatter()
                        dateDebPrint.dateFormat = "MMM d, yyyy, HH:mm"
                        if let debut = dateFormatterGet.date(from: deb) {
                            self.act_deb.append("Début:  \(dateFormatterPrint.string(from: debut))")
                            print(self.act_deb)
                        }
                        
                       
                        let fin = item["date_end"].stringValue
                        print("ATTTTTTTTT")
                        print(item["date_end"].stringValue)
                        let dateFinGet = DateFormatter()
                        dateFinGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let dateFinPrint = DateFormatter()
                        dateFinPrint.dateFormat = "MMM d, yyyy, HH:mm"
                        if let fin = dateFormatterGet.date(from: fin) {
                            self.act_fin.append("Fin:  \(dateFormatterPrint.string(from: fin))")
                            print(self.act_fin)
                        }
                        
                        let min = item["min_student"].stringValue
                        let max = item["max_student"].stringValue
                        self.act_grp.append("Groupes  \(min) min / \(max) max")
                        
                        
                        
                    }
                    if aa == "quest" {
                        let id = item["id"].stringValue
                        self.act_id.append(id)
                        
                        let nom = item["name"].stringValue
                        self.act_nom.append(nom)
                        
                        let ins = item["registration_date"].stringValue
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let dateFormatterPrint = DateFormatter()
                        dateFormatterPrint.dateFormat = "MMM d, yyyy"
                        
                        if let date = dateFormatterGet.date(from: ins) {
                            self.act_insc.append("Inscription:  \(dateFormatterPrint.string(from: date)) à")
                            
                        } else {
                            print("There was an error decoding the string")
                        }
                        
                        let dateHFormatterPrint = DateFormatter()
                        dateHFormatterPrint.dateFormat = "HH:mm"
                        
                        let insH = item["registration_date"].stringValue
                        if let Heure = dateFormatterGet.date(from: insH) {
                            self.act_inscH.append((dateHFormatterPrint.string(from: Heure)))
                            
                            
                        } else {
                            print("There was an error decoding the string")
                        }
                        
                        let deb = item["date_start"].stringValue
                        let dateDebGet = DateFormatter()
                        dateDebGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let dateDebPrint = DateFormatter()
                        dateDebPrint.dateFormat = "MMM d, yyyy, HH:mm"
                        if let debut = dateFormatterGet.date(from: deb) {
                            self.act_deb.append("Début:  \(dateFormatterPrint.string(from: debut))")
                            print(self.act_deb)
                        }
                        
                        let fin = item["date_end"].stringValue
                        let dateFinGet = DateFormatter()
                        dateFinGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let dateFinPrint = DateFormatter()
                        dateFinPrint.dateFormat = "MMM d, yyyy, HH:mm"
                        if let fin = dateFormatterGet.date(from: fin) {
                            self.act_fin.append("Fin:  \(dateFormatterPrint.string(from: fin))")
                            print(self.act_fin)
                        }
                        
                        
                        let min = item["min_student"].stringValue
                        let max = item["max_student"].stringValue
                        self.act_grp.append("Groupes  \(min) min / \(max) max")
                        
                    }
                    
                    
                }
                self.ViewCollection.dataSource = self
                self.ViewCollection.delegate = self
                self.ViewCollection.collectionViewLayout = UICollectionViewFlowLayout()
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
                        
                        // self.email.text = data["email"].string!
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
    
    var Item: String = ""
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.Item = self.act_id[indexPath.item]
        print(self.Item)
        performSegue(withIdentifier: Rendu, sender: Item)
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
          if segue.identifier == Rendu {
            if let vc = segue.destination as? GitController {
                vc.actid = self.Item
                vc.modid = Mid
            }
          }
            if segue.identifier == Formulaire {
                if let vc = segue.destination as? DeclaratifController {
                    vc.id = Mid
                }
            }
        }
}


// Extension afin de gérer les collectionView permettant d'afficher les informations
extension ActivitieController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return act_nom.count
    }
    
    //Fonction permettant de gérer l'affichage des modules depuis le fichier "displaymoduleCell"
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCollectionViewCell", for: indexPath) as! ActivityCollectionViewCell
        cell.nom.text = self.act_nom[indexPath.row]
        cell.ins.text = self.act_insc[indexPath.row]
        cell.inscH.text = self.act_inscH[indexPath.row]
        cell.debut.text = self.act_deb[indexPath.row]
        cell.fin.text = self.act_fin[indexPath.row]
        cell.groupe.text = self.act_grp[indexPath.row]
 
        return cell
    }
}

//Fonction qui définit la taille de la collectionView.
extension ActivitieController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftAndRightPaddings: CGFloat = 10.0
        let bottomPadding: CGFloat = 20.0
        let numberOfItemsPerRow: CGFloat = 1
        let width = (collectionView.frame.width-leftAndRightPaddings-bottomPadding)/numberOfItemsPerRow
        return CGSize(width: 375, height: 221)
    }
    
    func roundCorner() {
        self.ViewCollection.layer.cornerRadius = 12.0
        self.ViewCollection.layer.masksToBounds = true
        self.ViewCollection.layer.borderWidth = 1.0
        self.ViewCollection.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}




