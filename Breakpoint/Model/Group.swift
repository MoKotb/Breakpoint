import Foundation

class Group{
    
    public private(set) var groupId:String!
    public private(set) var groupTitle:String!
    public private(set) var groupDescription:String!
    public private(set) var groupMembers:[String]!
    public private(set) var groupCount:Int!
    
    init(groupId:String,groupTitle:String,groupDescription:String,groupMembers:[String],groupCount:Int) {
        self.groupId = groupId
        self.groupTitle = groupTitle
        self.groupDescription = groupDescription
        self.groupMembers = groupMembers
        self.groupCount = groupCount
    }
}
