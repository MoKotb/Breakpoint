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
        let feed = ["message":message,"senderId":userID]
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(feed)
        }else{
            REF_FEEDS.childByAutoId().updateChildValues(feed)
        }
        completion(true)
    }
    
    func getAllMessagesByGroup(group:Group,completion:@escaping (_ messages:[Message])->()){
        var messagesArray = [Message]()
        REF_GROUPS.child(group.groupId).child("messages").observeSingleEvent(of: .value) { (feedsSnapShot) in
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
    
    func getEmailsByGroup(group:Group,completion:@escaping (_ userEmail:[String])->()) {
        var groupUsers = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (usersSnapshot) in
            guard let snapShot = usersSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in snapShot{
                if group.groupMembers.contains(user.key){
                    let email = user.childSnapshot(forPath: "email").value as! String
                    groupUsers.append(email)
                }
            }
            completion(groupUsers)
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
    
    func searchUsersByEmail(searchKey:String,completion:@escaping (_ users:[String])->()){
        var usersArray = [String]()
        REF_USERS.observe(.value) { (UsersSnapShot) in
            guard let snapShot = UsersSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in snapShot{
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                if userEmail != Auth.auth().currentUser?.email && userEmail.contains(searchKey){
                    usersArray.append(userEmail)
                }
            }
            completion(usersArray)
        }
    }
    
    func getUsersIdByEmail(emails:[String],completion:@escaping (_ ids:[String])->()){
        var usersIdArray = [String]()
        REF_USERS.observeSingleEvent(of: .value){ (UsersSnapShot) in
            guard let snapShot = UsersSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in snapShot{
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                if emails.contains(userEmail){
                    usersIdArray.append(user.key)
                }
            }
            completion(usersIdArray)
        }
    }
    
    func createNewGroup(title:String,description:String,ids:[String],completion:@escaping (_ status:Bool)->()){
        let group = ["title":title,"description":description,"members":ids] as [String : Any]
        REF_GROUPS.childByAutoId().updateChildValues(group)
        completion(true)
    }
    
    func getAllGroups(completion:@escaping (_ groups:[Group])->()){
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupsSnapShot) in
            guard let snapShot = groupsSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for group in snapShot{
                let members = group.childSnapshot(forPath: "members").value as! [String]
                if members.contains(Auth.auth().currentUser!.uid){
                    let groupId = group.key
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    let newGroup = Group(groupId: groupId, groupTitle: title, groupDescription: description, groupMembers: members, groupCount: members.count)
                    groupsArray.append(newGroup)
                }
            }
            completion(groupsArray)
        }
    }
}
