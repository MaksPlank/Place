

import UIKit
import Firebase

class ButtonsVC: UIViewController {

    @IBOutlet weak var notes: UIButton!
    @IBOutlet weak var chat: UIButton!
    @IBOutlet weak var places: UIButton!
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var signout: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes.layer.cornerRadius = 15
        chat.layer.cornerRadius = 15
        places.layer.cornerRadius = 15
        }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        do {
        try Auth.auth().signOut()
        } catch {
        print(error.localizedDescription)
        }
         
        self.dismiss(animated: true, completion: nil)
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


