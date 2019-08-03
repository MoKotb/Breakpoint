import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            guard let tabVC = storyboard?.instantiateViewController(withIdentifier: "TabbarController") else { return }
            present(tabVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        
    }
    
    @IBAction func loginByEmail(_ sender: Any) {
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: LOGIN_VC_IDENTIFIER) as? LoginVC else { return }
        present(loginVC, animated: true, completion: nil)
    }
}
