 //  TaskVC.swift
 //  Hello
 //  Created by Maks Plank on 07.10.2020.
 
 
 import UIKit
 import Firebase
 import FirebaseDatabase

 class ItemSheet: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var userBox : Сlient!          // box for id (for save)
    var ref: DatabaseReference!
    var dataArray = Array<Data>()  // box foe array (for save)
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var custHeight: NSLayoutConstraint?
    var custBottom: NSLayoutConstraint?
    
    
    
    
    
//MARK: - viewDidLoad -
    // ID for userBox.uid +  Firebase link = users/user/tasks/
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUserId = Auth.auth().currentUser else { return }
           userBox = Сlient(userInit: currentUserId) // currentUser.uid & currentUser.email
           ref = Database.database().reference(withPath: "users").child(String(userBox.uid)).child("tasks")

        
        //MARK: -  Paralax Effect : for header -
        guard let header = tableView.tableHeaderView else { return }
           if let image = header.subviews.first as? UIImageView {
              custHeight = image.constraints.filter{ $0.identifier == "heightMark" }.first
              custBottom = header.constraints.filter{ $0.identifier == "bottomMark" }.first
              }
           let offSetY = tableView.contentOffset.y
               custHeight?.constant = max(header.bounds.height, header.bounds.height + offSetY)
               custBottom?.constant = offSetY >= 0 ? 0 : offSetY / 2
           header.clipsToBounds = offSetY <= 0
           }
    
//MARK: - viewWillAppear -
    // Set observer + Get data from Firebase
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        // наблюдаем за значением и получаем snapShot
        ref.observeSingleEvent(of: .value) { [weak self] (snapShot) in
            var _dataArray = Array<Data>()
            for item in snapShot.children  {
                let dataRow = Data(snapShotInit: item as! DataSnapshot)
                _dataArray.append(dataRow)
                }
            self?.dataArray = _dataArray
            self?.tableView.reloadData()
            }
        }
    
//MARK: - viewWillDisappear :
    // delete observer
    override func viewWillDisappear(_ animated: Bool) {
       super .viewWillDisappear(true)
       ref.removeAllObservers()
       }
        
        
    
//MARK: - TABLE -
    // show data from Firebase : .Title
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Row", for: indexPath)
       cell.backgroundColor = .clear
    
       let data = dataArray[indexPath.row]
       let dataTitle = data.title
       let dataMark = data.mark
    
       cell.textLabel?.text = dataTitle
    
       markMake(cell, mark: dataMark)
       return cell
       }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return dataArray.count }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
         let dataTitle = dataArray[indexPath.row]
         dataTitle.ref?.removeValue()
         }
       }
    
    
    // Add done- Marker
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       guard let cellRow = tableView.cellForRow(at: indexPath) else { return }
       let dataTitle = dataArray[indexPath.row]
       let dataMark = !dataTitle.mark
    
       markMake(cellRow, mark: dataMark)
       dataTitle.ref?.updateChildValues(["mark" : dataMark])
       }
    
        // .Mark
        func markMake(_ cell: UITableViewCell, mark: Bool) {
        cell.accessoryType = mark ? .checkmark : .none
        }


    
//MARK: - ADD -
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "Text me", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                
         let save = UIAlertAction(title: "Save", style: .cancel) { [weak self] _ in
             guard let textF = controller.textFields?.first, textF.text != "" else { return }
                    
         // MARK: - Save Data in FIREBASE -
        let data = Data(title: textF.text!, userId: (self?.userBox.uid)!)
        let taskWay = self?.ref.child(data.title.lowercased())
        taskWay?.setValue(data.convertToDict())
        }
                
       controller.addTextField()
       controller.addAction(cancel)
       controller.addAction(save)
       present(controller, animated: true, completion: nil)
       }
        
    
//MARK: - SIGN OUT / CLOSE -
    @IBAction func signOutAction(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let close = UIAlertAction(title: "Close", style: .default) { _ in
           self.dismiss(animated: true, completion: nil)
           }
        
        let signOut = UIAlertAction(title: "Sign Out", style: .default) { _ in
           do {
           try Auth.auth().signOut()
           } catch {
           print(error.localizedDescription)
           }
            
           self.dismiss(animated: true, completion: nil)
           }
        
        actionSheet.addAction(signOut)
        actionSheet.addAction(close)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
        }


}
 
