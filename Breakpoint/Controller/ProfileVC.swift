import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var profileTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userEmail.text = Auth.auth().currentUser?.email
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
        present(logout, animated: true, completion: nil)
    }
    
    private func configureLogout(){
        do{
            try Auth.auth().signOut()
            guard let authVC = self.storyboard?.instantiateViewController(withIdentifier: AUTH_VC_IDENTIFIER) as? AuthVC else { return }
            self.present(authVC, animated: true, completion: nil)
        }catch{
            print(error.localizedDescription)
        }
    }
}
