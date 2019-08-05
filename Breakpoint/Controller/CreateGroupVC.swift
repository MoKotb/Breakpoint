import UIKit
import Firebase

class CreateGroupVC: UIViewController {

    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var descriptionTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var usersEmail: UILabel!
    @IBOutlet weak var emailsTable: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var usersEmailArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        emailsTable.delegate = self
        emailsTable.dataSource = self
        emailTextField.delegate = self
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        doneButton.isHidden = true
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismissDetails()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard let title = titleTextField.text , titleTextField.text != "" else { return }
        guard let description = descriptionTextField.text , descriptionTextField.text != "" else { return }
        prepareToCreateGroup(title: title, description: description)
    }
    
    private func prepareToCreateGroup(title:String,description:String){
        if chosenUserArray.count > 0 {
            DataService.instance.getUsersIdByEmail(emails: chosenUserArray) { (usersId) in
                var ids = usersId
                guard let meId = Auth.auth().currentUser?.uid else { return }
                ids.append(meId)
                self.createGroup(title: title, description: description, ids: ids)
            }
        }
    }
    
    private func createGroup(title:String,description:String,ids:[String]){
        DataService.instance.createNewGroup(title: title, description: description, ids: ids, completion: { (Success) in
            if Success {
                self.dismissDetails()
            }else{
                debugPrint("CreateGroupVC.createGroup() not completed")
            }
        })
    }
}

extension CreateGroupVC: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: USER_CELL, for: indexPath) as? UserCell{
            let user = usersEmailArray[indexPath.row]
            if chosenUserArray.contains(user){
                cell.configureCell(email: user, selected: true)
            }else{
                cell.configureCell(email: user, selected: false)
            }
            return cell
        }else{
            return UserCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UserCell{
            if !chosenUserArray.contains(cell.userEmail.text!){
                chosenUserArray.append(cell.userEmail.text!)
                usersEmail.text = chosenUserArray.joined(separator: ", ")
                doneButton.isHidden = false
            }else{
                chosenUserArray = chosenUserArray.filter({ $0 != cell.userEmail.text!})
                if chosenUserArray.count > 0 {
                    usersEmail.text = chosenUserArray.joined(separator: ", ")
                }else{
                    usersEmail.text = "add people to your group"
                    doneButton.isHidden = true
                }
            }
        }
    }
}

extension CreateGroupVC: UITextFieldDelegate{
    
    @objc func textFieldDidChange(){
        if emailTextField.text == ""{
            usersEmailArray = []
            emailsTable.reloadData()
        }else{
            guard let key = emailTextField.text else { return }
            DataService.instance.searchUsersByEmail(searchKey: key) { (users) in
                self.usersEmailArray = users
                self.emailsTable.reloadData()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField{
            descriptionTextField.becomeFirstResponder()
        }else if textField == descriptionTextField{
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField{
            view.endEditing(true)
        }
        return true
    }
    
}
