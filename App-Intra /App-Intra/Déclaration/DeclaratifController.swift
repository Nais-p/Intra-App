//
//  DeclaratifController.swift
//  App-Intra
//
//  Created by Lucie Granier on 15/04/2021.
//

import UIKit
import Alamofire
import SafariServices

class DeclaratifController: UIViewController {
    
    @IBOutlet weak var Debut: UITextField!
    @IBOutlet weak var Hdebut: UILabel!
    @IBOutlet weak var Fin: UITextField!
    @IBOutlet weak var Hfin: UILabel!
    @IBOutlet weak var Objectifs: UITextField!
    @IBOutlet weak var Hobjectifs: UILabel!
    @IBOutlet weak var Actions: UITextField!
    @IBOutlet weak var Hactions: UILabel!
    @IBOutlet weak var Resultats: UITextField!
    @IBOutlet weak var Hresultats: UILabel!
    
    var obj = ""
    var act = ""
    var result = ""
    
    var id = ""
    func GoToHome(){
        let storyboard = UIStoryboard(name:"Main" , bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "home")
        vc.modalPresentationStyle = .overFullScreen
       
        present(vc, animated: true)
    }
    
    //Création de l'alerte
    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "The information entered are invalid. Please try again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    var aa = "Tesst 2"
    // A l'appui sur le bouton on envoie les infos si correct déclaration envoyer à l'intra sinon alerte
    @IBAction func Declaration(_ sender: Any) {
        obj = Objectifs.text!
        act = Actions.text!
        result = Resultats.text!
        let parameters :[String: Any]  = ["module": id,"declaration": [
            "start": Debut.text!,
            "end": Fin.text!,
            "content": "Objectifs: \n\(obj)\nActions: \n\(act)\nRésultats: \n\(result)\n"
        ], "sosJawa": false]
        
        AF.request(URL(string: "https://intra-api.etna-alternance.net/modules/\(id)/declareLogs")!, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            if response.response!.statusCode == 200 {
                print("TOUT EST BON")
                self.GoToHome()
            } else {
                print("CA VA PAS")
                self.presentAlert()
            }
        }
        print(obj)
        print(act)
        print(result)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)
    }
}
