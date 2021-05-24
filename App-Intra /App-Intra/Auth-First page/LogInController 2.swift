//
//  LogInController.swift
//  App-Intra
//
//  Created by Anaïs Puig on 08/04/2021.
//

import SwiftyJSON
import UIKit
import Alamofire

class LogInController: UIViewController {
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    func GoToHome(){
        let storyboard = UIStoryboard(name:"Main" , bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "home")
        vc.modalPresentationStyle = .overFullScreen
        //view.window?.makeKeyAndVisible()
        present(vc, animated: true)
    }
    
    //Création de l'alerte
    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "The information entered are invalid. Please try again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
// FONCTION A SUUPPRIMER
    @IBAction func del(_ sender: Any) {
        let myUrl: URL = URL(string: "https://auth.etna-alternance.net/identity")!
        var myRequest: URLRequest = URLRequest(url: myUrl);
        myRequest.httpMethod = "delete";
        
        let task = URLSession.shared.dataTask(with: myRequest) { [self]data, response, error in
            let json: String = String(data: data!, encoding: .utf8)!
            let statusCode = (response as! HTTPURLResponse).statusCode;
            if(statusCode == 200){
                DispatchQueue.main.async {
                }
            }else {
                DispatchQueue.main.async {
                }
            }
        }
        task.resume()
    }
    
    // A l'aapui sur le bouton on envoie les identifiant si correct accès à l'intra sinon alerte
    @IBAction func login(_ sender: Any) {
        let myUrl: URL = URL(string: "https://auth.etna-alternance.net/identity")!
        var myRequest: URLRequest = URLRequest(url: myUrl);
        myRequest.httpMethod = "POST";
        
        //Récupérarion des paramètres
        let postString = "login=\(login.text!)&password=\(password.text!)"
        //print("poststring-->>",postString)
        
        myRequest.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: myRequest) { [self]data, response, error in
            let _: String = String(data: data!, encoding: .utf8)!
            
            let statusCode = (response as! HTTPURLResponse).statusCode;
            if(statusCode == 200){
                DispatchQueue.main.async {
                    GoToHome()
                }
            }else {
                DispatchQueue.main.async {
                    presentAlert()
                }
            }
        }
        task.resume()
    }
}




