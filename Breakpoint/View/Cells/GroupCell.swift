import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var groupCount: UILabel!
    
    func configureCell(group:Group){
        groupTitle.text = group.groupTitle
        groupDescription.text = group.groupDescription
        groupCount.text = "\(group.groupCount ?? 0) members."
    }
}
