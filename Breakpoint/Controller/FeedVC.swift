import UIKit

class FeedVC: UIViewController {

    @IBOutlet weak var feedTable: UITableView!
    var messagesArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        feedTable.delegate = self
        feedTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadFeeds()
    }
    
    func downloadFeeds(){
        DataService.instance.REF_FEEDS.observe(.value) { (DataSnapshot) in
            DataService.instance.getAllFeeds { (messages) in
                self.messagesArray = messages.reversed()
                if self.messagesArray.count > 0 {
                    self.feedTable.isHidden = false
                    self.feedTable.reloadData()
                }else{
                    self.feedTable.isHidden = true
                }
            }
        }
    }
    
    @IBAction func createPostPressed(_ sender: Any) {
        presentToCreatePostVC()
    }
    
    private func presentToCreatePostVC(){
        guard let createPostVC = storyboard?.instantiateViewController(withIdentifier: CREATE_POST_VC_IDENTIFIER) as? CreatePostVC else { return }
        presentDetails(createPostVC)
    }
}

extension FeedVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FEED_CELL, for: indexPath) as? FeedCell{
            let message = messagesArray[indexPath.row]
            DataService.instance.getUserEmailByID(uid: message.senderId) { (userEamil) in
                cell.configureCell(email: userEamil, message: message.content)
            }
            return cell
        }else{
            return FeedCell()
        }
    }
}
