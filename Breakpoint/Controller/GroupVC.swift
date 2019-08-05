import UIKit
import Firebase

class GroupVC: UIViewController {

    @IBOutlet weak var groupTable: UITableView!
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        groupTable.delegate = self
        groupTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadGroups()
    }
    
    func downloadGroups(){
        DataService.instance.REF_GROUPS.observe(.value) { (DataSnapshot) in
            DataService.instance.getAllGroups { (groups) in
                self.groupsArray = groups.reversed()
                if self.groupsArray.count > 0 {
                    self.groupTable.isHidden = false
                    self.groupTable.reloadData()
                }else{
                    self.groupTable.isHidden = true
                }
            }
        }
    }
    
    @IBAction func addNewGroup(_ sender: Any) {
        presentToCreateGroupVC()
    }
    
    private func presentToCreateGroupVC(){
        guard let createGroupVC = storyboard?.instantiateViewController(withIdentifier: CREATE_GROUP_VC_IDENTIFIER) as? CreateGroupVC else { return }
        presentDetails(createGroupVC)
    }
}

extension GroupVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GROUP_CELL, for: indexPath) as? GroupCell{
            let group = groupsArray[indexPath.row]
            cell.configureCell(group: group)
            return cell
        }else{
            return GroupCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: GROUP_FEED_VC_IDENTIFIER) as? GroupFeedVC else { return }
        let group = groupsArray[indexPath.row]
        groupFeedVC.initData(group: group)
        presentDetails(groupFeedVC)
    }
}
