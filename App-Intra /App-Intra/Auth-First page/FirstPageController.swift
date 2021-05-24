//
//  FirstPageController.swift
//  App-Intra
//
//  Created by Anaïs Puig on 08/04/2021.
//

import SwiftyJSON
import UIKit
import Alamofire
import UserNotifications


class FirstPageController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func GoLogin(){
        let storyboard = UIStoryboard(name:"Main" , bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .overFullScreen
        //view.window?.makeKeyAndVisible()
        present(vc, animated: true)
    }
    @IBAction func buton(_ sender: Any) {
        GoLogin()
    }
    
    
    // Push notification
        @IBAction func Push(_ sender: Any) {
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Push notifs"
        content.body = "Voici une notif de l'intra !"
        content.sound = .default
        content.userInfo = ["value": "Data with local notification"]
        
        
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(2))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notifs", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
        
    }
}


