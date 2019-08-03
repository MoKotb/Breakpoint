import UIKit
import Firebase

class CreateGroupVC: UIViewController {

    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var descriptionTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var usersEmail: UILabel!
    @IBOutlet weak var emailsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
    }
}
