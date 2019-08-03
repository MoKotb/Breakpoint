import Foundation

class Message{
    
    public private(set) var content:String!
    public private(set) var senderId:String!
    
    init(content:String,senderId:String) {
        self.content = content
        self.senderId = senderId
    }
}
