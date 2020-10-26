 //  LoginVC.swift
 //  Hello
 //  Created by Maks Plank on 07.10.2020.
 
 

import UIKit
import Foundation
import Firebase
import FirebaseDatabase


class Login: UIViewController {

    var ref: DatabaseReference!
    private let IdentifierSegueTask = "taskWay"
    
    @IBOutlet weak var worningOutlet: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var regOutlet: UIButton!
    @IBOutlet weak var openOutlet: UIButton!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        ref = Database.database().reference(withPath: "users") // user wasn't enable yet
        
        regOutlet.layer.cornerRadius = 20
        loginOutlet.layer.cornerRadius = 20
        worningOutlet.alpha = 0
        openOutlet.layer.cornerRadius = 50
        passwordTextField.isSecureTextEntry = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       view.endEditing(true)
       }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.view.bounds.size.height * 2 , right: 0)
       }
    
    
    
    // Clean Login + Password после входа
    override func viewWillAppear(_ animated: Bool) {
       super .viewWillAppear(animated)
       passwordTextField.text = ""
       emailTextField.text = ""
       }
    
    
    
    
 //MARK: - KEYBOARD UP -
    
    @objc func kbDidShow(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        
    // + UIScrillView (storyboard for View)
    (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc func kbDidHide() {
    // восстановление исходного значения для контента
    (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    
    
    
    @IBAction func openAction(_ sender: UIButton) {
        // Check : (user, auth) for changes
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.IdentifierSegueTask)!, sender: nil)
                }
            }
    }
    
    
    
//MARK: - Worning (worningOutlet) -
    func worningText(WithText text: String) {
       worningOutlet.text = text
       // .curveEaseInOut = плавная анимация
        UIView.animate(withDuration: 7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
        self?.worningOutlet.alpha = 1
        }  completion: { _ in
        self.worningOutlet.alpha = 0
        }
    }
    
    
//MARK: - AUTHORIZATION
    // Метод для авторизации пользователя (если он существует) : кнопка Login -
    @IBAction func loginAction(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
        self.worningText(WithText: "Wrong password or email!")
        return
        }
        
    // AUTHORIZATION into Firebase
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
    // no error :
       if error != nil {
       self?.worningText(WithText: "Error")
       return
       }
    // user is exist :
       if user != nil {
       self?.performSegue(withIdentifier: "taskWay", sender: nil)
       }
    
       self?.worningText(WithText: "No such user")
       }
    }
    
    
//MARK: - REGESRTATION -
    // Метод для регестрации пользователя (если он существует) : кнопка Register -
    @IBAction func registerAction(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
        self.worningText(WithText: "Wrong password or email !")
        return
        }
    
    // REGESRTATION into Firebase
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
    // У пользователя появляется email в Firebas >> TaskVC уже с заполненным полем для почты
        guard error == nil, user != nil else {
        print(error!.localizedDescription)
        return
        }
        
        let userRef = self?.ref.child((user?.user.uid)!)
        userRef?.setValue(["email": email])
        }
    }
    
    
    
    
}


