import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var membersText: UILabel!
    @IBOutlet weak var feedTable: UITableView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var messageTextField: CustomTextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var group:Group?
    var groupMessages = [Message]()
    
    func initData(group:Group){
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        feedTable.delegate = self
        feedTable.dataSource = self
        groupTitle.text = group?.groupTitle
        DataService.instance.getEmailsByGroup(group: group!) { (emails) in
            self.membersText.text = emails.joined(separator: ", ")
        }
        sendView.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadGroupFeed()
    }
    
    func downloadGroupFeed(){
        DataService.instance.REF_GROUPS.observe(.value) { (data) in
            DataService.instance.getAllMessagesByGroup(group: self.group!, completion: { (returnMessages) in
                self.groupMessages = returnMessages
                self.feedTable.reloadData()
                if self.groupMessages.count > 0 {
                    let index = IndexPath(row: self.groupMessages.count - 1, section: 0)
                    self.feedTable.scrollToRow(at: index, at: .bottom, animated: true)
                }
            })
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismissDetails()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let message = messageTextField.text , messageTextField.text != "" else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        prepareToSendMessage(message: message, userId: userId)
    }
    
    private func prepareToSendMessage(message:String,userId:String){
        sendButton.isEnabled = false
        messageTextField.isEnabled = false
        DataService.instance.uploadNewPost(message: message, userID: userId, groupKey: group?.groupId) { (Success) in
            if Success {
                self.messageTextField.text = ""
            }
            self.sendButton.isEnabled = true
            self.messageTextField.isEnabled = true
        }
    }
}

extension GroupFeedVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GROUP_FEED_CELL, for: indexPath) as? GroupFeedCell{
            let message = groupMessages[indexPath.row]
            DataService.instance.getUserEmailByID(uid: message.senderId) { (userEamil) in
                cell.configureCell(email: userEamil, message: message.content)
            }
            return cell
        }else{
            return GroupFeedCell()
        }
    }
}
