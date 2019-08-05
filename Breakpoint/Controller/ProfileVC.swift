import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var profileTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmail.text = Auth.auth().currentUser?.email
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        showAlert()
    }
    
    private func showAlert(){
        let logout = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            self.configureLogout()
        }
        logout.addAction(logoutAction)
        presentDetails(logout)
    }
    
    private func configureLogout(){
        do{
            try Auth.auth().signOut()
            guard let authVC = self.storyboard?.instantiateViewController(withIdentifier: AUTH_VC_IDENTIFIER) as? AuthVC else { return }
            self.presentDetails(authVC)
        }catch{
            debugPrint("ProfileVC.configureLogout() \(error.localizedDescription)")
        }
    }
}
