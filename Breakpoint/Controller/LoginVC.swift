import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTap()
    }
    
    private func handleTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func closeKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        getUserData()
    }
    
    private func getUserData(){
        guard let email = emailTextField.text , emailTextField.text != nil else { return }
        guard let password = passwordTextField.text , passwordTextField.text != nil else { return }
        let emailLower = email.lowercased()
        loginUser(email: emailLower, password: password)
    }
    
    private func loginUser(email:String,password:String){
        AuthService.instance.loginUser(email: email, userPassword: password) { (Success, error) in
            if Success {
                guard let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarController") else { return }
                self.present(tabVC, animated: true, completion: nil)
            }else{
                print("loginUser \(String(describing: error?.localizedDescription))")
            }
            self.registerUser(email: email, password: password)
        }
    }
    
    private func registerUser(email:String,password:String){
        AuthService.instance.registerUser(email: email, userPassword: password) { (Success, error) in
            if Success {
                self.loginUser(email: email, password: password)
                guard let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarController") else { return }
                self.present(tabVC, animated: true, completion: nil)
            }else{
                print("registerUser \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
