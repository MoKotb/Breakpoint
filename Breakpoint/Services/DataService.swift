import Foundation
import Firebase

class DataService{
    
    static let instance = DataService()
    
    public private(set) var REF_BASE = DB_BASE
    public private(set) var REF_USERS = DB_BASE.child("users")
    public private(set) var REF_GROUPS = DB_BASE.child("groups")
    public private(set) var REF_FEEDS = DB_BASE.child("feeds")
    
    func createNewUser(userID:String,userData:Dictionary<String,Any>){
        REF_USERS.child(userID).setValue(userData)
    }
    
    func uploadNewPost(message:String,userID:String,groupKey:String?,completion:@escaping (_ status:Bool)->()){
        if groupKey != nil {
            
        }else{
            let feed = ["message":message,"senderId":userID]
            REF_FEEDS.childByAutoId().updateChildValues(feed)
            completion(true)
        }
    }
    
    func getUserEmailByID(uid:String,completion:@escaping (_ userEmail:String)->()) {
        REF_USERS.observeSingleEvent(of: .value) { (usersSnapshot) in
            guard let snapShot = usersSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in snapShot{
                if user.key == uid {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    completion(email)
                }
            }
        }
    }
    
    func getAllFeeds(completion:@escaping (_ messages:[Message])->()){
        var messagesArray = [Message]()
        REF_FEEDS.observeSingleEvent(of: .value) { (feedsSnapShot) in
            guard let snapShot = feedsSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for feed in snapShot{
                let content = feed.childSnapshot(forPath: "message").value as! String
                let id = feed.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: id)
                messagesArray.append(message)
            }
            completion(messagesArray)
        }
    }
    
}
