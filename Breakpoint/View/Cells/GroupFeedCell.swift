import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var messageContent: UILabel!
    
    func configureCell(email:String,message:String){
        userEmail.text = email
        messageContent.text = message
    }
}
