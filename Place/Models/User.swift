
import Foundation
import Firebase

struct Сlient {
    
    let uid: String
    let email: String
    
    // инициирует готового пользователя : currentUserId
    init(userInit: User) {
        self.uid = userInit.uid
        self.email = userInit.email!
    }
}
