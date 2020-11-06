//
//  ChatOne.swift
//  Place
//
//  Created by Maks Plank on 06.11.2020.
//

import UIKit

class ChatOne: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9071481228, green: 0.8948236108, blue: 0.8418112397, alpha: 1)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // keep user-info 'LogIn/Out' : UserDefaults
        let isLogged = UserDefaults.standard.bool(forKey: "log_in")
        
        if !isLogged {
            let vc = Login()
            let nav = UINavigationController(rootViewController: vc)
            
        }
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
