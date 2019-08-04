import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    
    var selectedShow = false
    
    func configureCell(email:String,selected:Bool){
        userEmail.text = email
        if selected {
            selectedIcon.isHidden = false
            selectedShow = true
        }else{
            selectedIcon.isHidden = true
            selectedShow = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if !selectedShow{
                selectedIcon.isHidden = false
                selectedShow = true
            }else{
                selectedIcon.isHidden = true
                selectedShow = false
            }
        }
    }
}
