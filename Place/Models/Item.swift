
//MARK: Let's Create Struct for JSON-Data from Forebase !

import Foundation
import FirebaseDatabase

struct Data {
    
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var mark : Bool = false
    
    // For CREATE object localy
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    // For FETCH data
    init(snapShotInit: DataSnapshot) {
        let snapShotValue = snapShotInit.value as! [String: AnyObject]
        title = snapShotValue["title"] as! String
        userId = snapShotValue["userId"] as! String
        mark = snapShotValue["mark"] as! Bool
        ref = snapShotInit.ref
    }
    
    
    // (3) Dictionaty to adress -  taskWay - key : value
    func convertToDict() -> Any {
        return ["title": title, "userId": userId, "mark": mark]
    }
    
}
