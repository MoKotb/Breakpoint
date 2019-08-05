import Foundation
import Firebase

class AuthService {
    
    static let instance = AuthService()
    
    func registerUser(email:String,userPassword:String, completion: @escaping (_ status:Bool,_ error:Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: userPassword) { (user, error) in
            guard let newUser = user else {
                completion(false,error)
                return
            }
            let userData = ["provider":newUser.user.providerID,"email":newUser.user.email]
            DataService.instance.createNewUser(userID: newUser.user.uid, userData: userData as Dictionary<String, Any>)
            completion(true,nil)
        }
    }
    
    func loginUser(email:String,userPassword:String, completion: @escaping (_ status:Bool,_ error:Error?) -> ())  {
        Auth.auth().signIn(withEmail: email, password: userPassword) { (user, error) in
            if error != nil{
                completion(false,error)
            }
            completion(true,nil)
        }
    }
}
