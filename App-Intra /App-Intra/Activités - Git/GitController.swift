//
//  GitController.swift
//  App-Intra
//
//  Created by Anaïs Puig on 15/04/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

class GitController: UIViewController {
    var actid = ""
    var modid = ""
    var ordi = ""
    func Url() {
        AF.request("https://modules-api.etna-alternance.net/\(modid)/activities/\(actid)").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        
                        let rendu = data["rendu"]
                        print("aze")
                        print(rendu)
                        self.url.text = rendu.string!
                        self.ordi = rendu.string!
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
    @IBAction func git(_ sender: Any) {
        let vc = SFSafariViewController(url: URL(string: self.ordi)!)
        present(vc, animated: true)
    }
    @IBOutlet weak var url: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MODULE \(modid)")
        print("LAAAAAAAa \(actid)")
        Url()
    }
}
