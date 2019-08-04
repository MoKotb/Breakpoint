import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var messageContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageContent.delegate = self
        sendButton.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userEmail.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        guard let message = messageContent.text , messageContent.text != "" , messageContent.text != "Say something here ..." else { return }
        self.sendButton.isEnabled = false
        sendMessageData(message: message)
    }
    
    private func sendMessageData(message:String){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        DataService.instance.uploadNewPost(message: message, userID: userId, groupKey: nil) { (Success) in
            if Success {
                self.dismiss(animated: true, completion: nil)
            }
            self.sendButton.isEnabled = true
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePostVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageContent.text = ""
    }
}
