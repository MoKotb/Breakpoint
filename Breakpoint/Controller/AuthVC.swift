import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userLoggedIn()
    }
    
    func userLoggedIn(){
        if Auth.auth().currentUser != nil{
            presentToTabbar()
        }
    }
    
    func presentToTabbar(){
        guard let tabVC = storyboard?.instantiateViewController(withIdentifier: "TabbarController") else { return }
        presentDetails(tabVC)
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        
    }
    
    @IBAction func loginByEmail(_ sender: Any) {
        moveToLoginVC()
    }
    
    func moveToLoginVC(){
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: LOGIN_VC_IDENTIFIER) as? LoginVC else { return }
        presentDetails(loginVC)
    }
}
