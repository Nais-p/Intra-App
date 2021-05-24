import SwiftyJSON
import UIKit
import Alamofire
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var promo: UILabel!
    @IBOutlet weak var ViewCollection: UICollectionView!
    
    // Déclaration des variables "globales"
    var Strlogin: String = ""
    var Strpromo = ""
    
    let viewImageSegueIdentifier = "viewImageSegueIdentifier"
    var id_module = ""
    
    // Variable permettant l'affichage des modules dans collection view
    var uv_name = [String]()
    var uv_lname = [String]()
    var uv_id = [String]()
    
    //Fonction permettant de récupérer la promo, le nom et prénom correspondant au login actuel
    func User() {
        //Récupération du login de l'utilisateur afin d'effectuer la requête
        let defaults = UserDefaults.standard
        let my_login = defaults.string(forKey: "Strlogin")
        
        AF.request("https://intra-api.etna-alternance.net/users/\(my_login!)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        
                        self.lastname.text = data["lastname"].string!
                        self.firstname.text = data["firstname"].string!
                        
                        self.Strpromo = data["promo"].string!
                        let pro = "Promo \(self.Strpromo)     "
                        self.promo.text =  pro
                    }
                    catch{
                        //print("JSON Error")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Fonction permettant de récupérer la photo correspondante au login de la personne connectée
    func Photo() {
        let defaults = UserDefaults.standard
        let my_login = defaults.string(forKey: "Strlogin")
        
        let Picture = "https://auth.etna-alternance.net/api/users/\(my_login!)/photo"
        if let imageURL = URL(string: Picture) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.picture.image = image
                    }
                }
            }
        }
    }
    
    //Fonction permettant de récupérer les informations concernant les modules.
    func Module() {
        let defaults = UserDefaults.standard
        let my_login = defaults.string(forKey: "Strlogin")
        
        AF.request("https://intra-api.etna-alternance.net/students/\(my_login!)/sessions", encoding: URLEncoding.default).responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print(json)
                self.uv_lname.removeAll()
                self.uv_name.removeAll()
                self.uv_id.removeAll()
                
                for item in json.array!{
                    let lname = item["uv"]["long_name"].stringValue
                    self.uv_lname.append(lname)
                    
                    let name = item["uv"]["name"].stringValue
                    self.uv_name.append(name)
                    
                    let id = item["id"].stringValue
                    self.uv_id.append(id)
                
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
                        self.User()
                        self.Photo()
                        self.Module()
                        
                        self.email.text = data["email"].string!
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.Item = self.uv_id[indexPath.item]
        print(self.Item)
        performSegue(withIdentifier: viewImageSegueIdentifier, sender: Item)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      if segue.identifier == viewImageSegueIdentifier {
        if let vc = segue.destination as? ActivitieController {
            vc.Mid = self.Item
        }
      }
    }
}


// Extension afin de gérer les collectionView permettant d'afficher les informations
extension ViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uv_lname.count
    }
    
    //Fonction permettant de gérer l'affichage des modules depuis le fichier "displaymoduleCell"
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "displaymoduleCell", for: indexPath) as! displaymoduleCell
        cell.Name.text = self.uv_lname[indexPath.row]
        cell.Name2.text = self.uv_name[indexPath.row]
        return cell
    }
}

//Fonction qui définit la taille de la collectionView.
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let numberOfItemsPerRow: CGFloat = 2
        let width = (collectionView.frame.width-numberOfItemsPerRow)
        return CGSize(width: width, height: 150)
    }

    func roundCorner() {
        self.ViewCollection.layer.cornerRadius = 12.0
        self.ViewCollection.layer.masksToBounds = true
        self.ViewCollection.layer.borderWidth = 1.0
        self.ViewCollection.layer.borderColor = UIColor.clear.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top, left, bottom, right
        return UIEdgeInsets(top: 30, left: 0, bottom: 100, right: 0)
    }
}




