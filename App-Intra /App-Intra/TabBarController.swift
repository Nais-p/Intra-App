//
//  TabBarController.swift
//  App-Intra
//
//  Created by Anaïs Puig on 08/04/2021.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func GoLogin(){
        let storyboard = UIStoryboard(name:"Main" , bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "The information entered are invalid. Please try again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Fonction permettant de se déconnecter (supp cookie) pour ensuite pouvoir se reco
    @IBAction func out(_ sender: Any) {
        let myUrl: URL = URL(string: "https://auth.etna-alternance.net/identity")!
        var myRequest: URLRequest = URLRequest(url: myUrl);
        myRequest.httpMethod = "DELETE";
        
        let task = URLSession.shared.dataTask(with: myRequest) { [self]data, response, error in
            let json: String = String(data: data!, encoding: .utf8)!
            
            let statusCode = (response as! HTTPURLResponse).statusCode;
            if(statusCode == 200){
                DispatchQueue.main.async {
                    GoLogin()
                }
                print ("All Good");
            }else {
                DispatchQueue.main.async {
                    presentAlert()
                }
            }
        }
        task.resume()
    }
}
